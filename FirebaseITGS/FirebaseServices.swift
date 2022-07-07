//
//  FirebaseServices.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import Foundation
import Firebase
import FirebaseStorage


let DB_BASE = Database.database().reference()
var DB_STROGE = Storage.storage().reference()
var chatTableReferance:DatabaseReference!


extension DatabaseReference{
    func updateChildValues( _ v: [String: Any]){
        var values: [String: Any] = [:]
        for (key, value) in v{
            values[key] = value
        }
        print("updated Firebase device token: \(values)")
        updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err)
            }
        }
    }
}

class FirebaseService {
    
    static let instance = FirebaseService()
    
    var usersBase = DB_BASE.child("contacts")
    var groupBase = DB_BASE.child("groups")
    var feebBase = DB_BASE.child("feeds")
    
    func getChatDatabaseRootRefrence() -> DatabaseReference {
        return Database.database().reference()
    }

    func databaseChats1 () -> DatabaseReference{
        let companyId = 50
        return self.getChatDatabaseRootRefrence().child("\(companyId)/Chat")
    }
    
    func databaseUsers () -> DatabaseReference{
        let companyId = 50
        return self.getChatDatabaseRootRefrence().child("\(companyId)/Users")
    }
    
    func databaseDeviceTokens () -> DatabaseReference{
        let companyId = 50
        return self.getChatDatabaseRootRefrence().child("\(companyId)/DeviceTokens")
    }
    
    func databaseMessages () -> DatabaseReference{
        let companyId = 50
        return self.getChatDatabaseRootRefrence().child("\(companyId)/Message")
    }
    
    func databaseGroupChat () -> DatabaseReference{
        let companyId = 50
        return self.getChatDatabaseRootRefrence().child("\(companyId)/Group")
    }
    
    func databaseNotification () -> DatabaseReference{
        return self.getChatDatabaseRootRefrence().child("Notification")
    }
    
    var fireBaseUserList = [User]()
    var messages = [Message]()
    var usersDetailsFromChatTable = [Any]()

    let chatConEmpty = ChatConversation(seen: "", emp_id: "", isfavorite: false, lastmsg: "", isarchived: false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: 1554965878540, isgroup: false, name: "", message_type: "", online: "", toChatId: "", isread: false, ismute: "false".encryptMessage(), profile_pic: "", from_id: "", isMsgSeenByReceiver: "",knownAs:"", usersDetailsArr: [], isGroupTitle: false, isremoved: false, message_key: "")
 
    func decryptTextMethod(text: String) -> String{
        if text.decryptMessage() ?? "" == ""{
            return text
        }else{
            return text.decryptMessage() ?? ""
        }
    }

    func decryptTextMethodWithFixedIV(text: String) -> String{
        if text.decryptMessageWithFixedIV() ?? "" == ""{
            return text
        }else{
            let textplain = text.decryptMessageWithFixedIV() ?? ""
            
            let utf8View: String.UTF8View = textplain.utf8

            let newString = String(decoding: utf8View, as: UTF8.self)

            return newString
        }
    }

    func createUser ( userID : String , userData : Dictionary<String,Any>){
        usersBase.child(userID).updateChildValues(userData)
    }
    
    func createPost(PostData: Dictionary<String , Any>){
        
        feebBase.childByAutoId().updateChildValues(PostData)
        
    }
    
    func createMessage(MessageData: String, groupId: String, type: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        groupBase.child(groupId).child("messages").childByAutoId().updateChildValues(["messageText": MessageData, "type": type, "email": Auth.auth().currentUser!.email!])
        sendComplete(true)
    }
    
    func fetchUserFromFireBase( handler: @escaping (_ usersArray: [User]) -> ()) {
        let query = self.databaseUsers().queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            if let myContacts = snapshot.value as? NSDictionary {
                self.fireBaseUserList.removeAll()
                for (_,value) in myContacts {
                    if let contactsData = value as? NSDictionary {
                        
                        let decryptedName = (contactsData.value(forKey: "name") as? String ?? "").decryptMessage() ?? ""
                        let decrypteOnlineStatus = (contactsData.value(forKey: "online") as? String ?? "").decryptMessage() ?? ""
                        let decryptedImage = (contactsData.value(forKey: "image") as? String ?? "").decryptMessage() ?? ""
                        let decryptedEmpId = (contactsData.value(forKey: "emp_id") as? String ?? "").decryptMessage() ?? ""
                        let decryptedKnownAs = (contactsData.value(forKey: "knownAs") as? String ?? "").decryptMessage() ?? ""
                        let decryptedEmpStatus = (contactsData.value(forKey: "employeeStatus") as? String ?? "").decryptMessage() ?? ""
                        
                        let user = User(UUID: contactsData.value(forKey: "uuid") as? String ?? "", deviceToken: contactsData.value(forKey: "deviceToken") as? String ?? "", name: decryptedName, online: decrypteOnlineStatus, image: decryptedImage, emp_id: decryptedEmpId, isSelected: false, deviceType: contactsData.value(forKey: "deviceType") as? String ?? "", knownAs: decryptedKnownAs, empStatus: decryptedEmpStatus)
                        
                        let id = contactsData["uuid"] as? String ?? ""
                        
                        let currentUserId = "currentFireUserId"
                        if currentUserId == "" {
                            return
                        }
                        if id == currentUserId as? String ?? ""  {
                            UserDefaults.standard.set(decryptedName, forKey: "fireUserName")
                            UserDefaults.standard.set(contactsData["uuid"] as? String ?? "", forKey: "fireUserId")
                            UserDefaults.standard.synchronize()
                        }else{
                            self.fireBaseUserList.append(user)
                        }
                    }
                }
                handler(self.fireBaseUserList)
            }
        })
    }

    func getToChatUserConversation(toUserId:String, currentUserId:String, handler: @escaping(ChatConversation) ->(Void)){
        
        if !toUserId.isEmpty && !currentUserId.isEmpty {
            let muteConvRef = self.databaseChats1().child(toUserId ).child(currentUserId )
            muteConvRef.keepSynced(true)
            muteConvRef.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    if  let messageDict = snapshot.value as? [String: Any]{
                        
                        let decryptedSeen = (messageDict["seen"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedName = (messageDict["name"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedMsgType = (messageDict["message_type"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedProfilePic = (messageDict["profile_pic"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedKnownAs = (messageDict["knownAs"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedOnline = (messageDict["online"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedMute = (messageDict["ismute"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedEmpId = (messageDict["emp_id"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedLastMsg = (messageDict["lastmsg"] as? String ?? "").decryptMessage() ?? ""
                        let decryptedIsMsgSeenByReceiver = (messageDict["isMsgSeenByReceiver"] as? String ?? "").decryptMessage() ?? ""

                        let conversation = ChatConversation(seen:decryptedSeen , emp_id: decryptedEmpId, isfavorite: messageDict["isfavorite"] as? Bool ?? false, lastmsg:  decryptedLastMsg, isarchived: messageDict["isarchived"] as? Bool ?? false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: messageDict["timestamp"] as? NSNumber ?? 0, isgroup: messageDict["isgroup"] as? Bool ?? false, name: decryptedName, message_type: decryptedMsgType, online: decryptedOnline, toChatId: messageDict["toChatId"] as? String ?? "", isread: messageDict["isread"] as? Bool ?? false, ismute: decryptedMute, profile_pic: decryptedProfilePic, from_id: messageDict["from_id"] as? String ?? "", isMsgSeenByReceiver: decryptedIsMsgSeenByReceiver, knownAs: decryptedKnownAs, usersDetailsArr:  messageDict["usersDetailsArr"] as? [String] ?? [], isGroupTitle: messageDict["isgroup_title"] as? Bool ?? false, isremoved: messageDict["isremoved"] as? Bool ?? false, message_key: messageDict["message_key"] as? String ?? "")
                        
                        muteConvRef.removeAllObservers()
                        handler(conversation)
                    }
                }else{
                    muteConvRef.removeAllObservers()
                    handler(self.chatConEmpty)
                }
            }
            muteConvRef.removeAllObservers()
        }
    }
    
    func unArchiveChatConversation(handler: @escaping(_ success: Bool) ->()) {
        
        let currentFirebaseUserId = ""//sss
        if currentFirebaseUserId == ""{
            print("Unarchiving Chat Conversation currentUserId nil in unarchiveChatConv method")
            handler(false)
            return
        }
        chatTableReferance = self.databaseChats1().child(currentFirebaseUserId)
        chatTableReferance.keepSynced(true)
        chatTableReferance.observe(.value) { (snapshot) in
            if snapshot.exists() {
                handler(true)
                if  (snapshot.value as? [String: Any]) != nil{
                }
            }else{
                handler(false)
            }
        }
    }


//MARK:- Auth Services
    
}
