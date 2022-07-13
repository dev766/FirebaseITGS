//
//  NewChatConversationViewModel.swift
//  ITGSchat
//
//  Created by S.S Bhati on 04/07/22.
//


import Foundation
import Firebase
import CoreTelephony

class NewChatConversationViewModel {
    
    static let instance = NewChatConversationViewModel()

    var groupMembers = [Any]()
    var messageRefSenderTestForSingle:DatabaseReference!
    var messageRefSenderTestChildChangedForSingle:DatabaseReference!
    var messageRefSenderPagingForSingle:DatabaseReference!
    var messageRefPreviousStructureForGroup:DatabaseReference!
    var messageRefSenderForGroup:DatabaseReference!
    var messageRefSenderPagingForGroup:DatabaseReference!
    var messages = [Message]()
    var allMessages = [Message]()
    var allMessagesGroups = [Message]()
    var firebaseService = FirebaseService()
    var sendMessageTimeStamp: NSNumber = 0
    var initialLoad = true
    var msgDateDict:[Date:[Message]] = [:]
    var dateKeysArr:[Date] = []
    var isInternetlimitedAccessEnable = false

    var msgEmpty = Message(timeStamp: 1554965878540, from_id: "", from_name: "", payload: "", mediaInfo1: "", mediaInfo2: "", seen: false, seenMembers: "", message_type: "", deliverd_status: "", isFileUploadedOnAWS: true, messageKey: "")
    var chatConEmpty = ChatConversation(seen: "", emp_id: "", isfavorite: false, lastmsg: "", isarchived: false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: 1554965878540, isgroup: false, name: "", message_type: "", online: "", toChatId: "", isread: false, ismute: "false".encryptMessage(), profile_pic: "", from_id: "", isMsgSeenByReceiver: "", knownAs: "", usersDetailsArr: [], isGroupTitle: false, isremoved: false, message_key: "")
    
    
    
    //MARK: - Clear Notification Tray for this chatn user
    
    func removeMsgTableObserver(){
        messageRefSenderTestChildChangedForSingle?.removeAllObservers()
        messageRefSenderTestForSingle?.removeAllObservers()
        messageRefSenderPagingForSingle?.removeAllObservers()
        messageRefPreviousStructureForGroup?.removeAllObservers()
        messageRefSenderForGroup?.removeAllObservers()
        messageRefSenderPagingForGroup?.removeAllObservers()
    }
    
    func clearNotificationOfToChatUser(){
        guard let toChatId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
        //////Remove notification from tray after opening perticular users chat
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            for aNoitfication in notifications{
                let identifier = aNoitfication.request.identifier
                let userInfo = aNoitfication.request.content.userInfo
                let notiFromUserId = userInfo["group_id"] != nil ? userInfo["group_id"] : userInfo["from_user_id"]
                if notiFromUserId as? String == toChatId {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
                }
            }
        }
    }

    func loadAllFireBaseMessage11InNewChat(snapshot: NSDictionary,completion:@escaping (ChatConversation) -> Void){
            
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
       
        if currentUserId == "" {
            return
        }
        
        var unreadCountStr = 0
        var conversation:ChatConversation!

        if let chat = snapshot as? NSDictionary {
                if let contactsData = chat as? [String:Any] {
                        
                    var decryptedSeen = ""

                    if let isGroup = contactsData["isgroup"] as? Bool,isGroup{
                        if contactsData["emp_id"] != nil{
                            let empid = FirebaseService.instance.decryptTextMethod(text:contactsData["emp_id"] as? String ?? "")
                            let timestamp = contactsData["timestamp"] as? NSNumber ?? 0
                                
                            ////set userDetailArray Name to group name if title not set
                            let nameArr:NSMutableArray = []
                            var chatTitleName:String = ""
                            var showGroupMembersNameAsgroupName = false
                                
                            var decryptedName = ""
                            decryptedName = FirebaseService.instance.decryptTextMethod(text:contactsData["name"] as? String ?? "")
                                
                            if (contactsData["usersDetailsArr"] as? [Any] ?? []).count > 0{
                                for (_,user) in (contactsData["usersDetailsArr"] as? [Any] ?? []).enumerated(){
                                    if let user2 = user as? [String:Any]{
                                        if contactsData["isgroup_title"] as? Bool ?? false{

                                            chatTitleName = decryptedName //contactsData["name"] as? String ?? ""
                                        }else{
                                            if (contactsData["usersDetailsArr"] as? [Any] ?? []).count <= 1{
                                                if currentUserId == user2["memberId"] as? String ?? ""{
                                                    chatTitleName = ""
                                                }
                                            }else{
                                                if currentUserId != user2["memberId"] as? String ?? ""{
                                                        
                                                    var userArrName = ""
                                                    let userArrNameString  = user2["name"] as? String
                                                    if userArrNameString?.decryptMessage() ?? "" == ""{
                                                        userArrName = userArrNameString ?? ""
                                                    }else{
                                                        userArrName = userArrNameString?.decryptMessage() ?? ""
                                                    }

                                                    nameArr.add(userArrName /*user2["name"] as? String ?? ""*/)
                                                    showGroupMembersNameAsgroupName = true
                                                }
                                            }
                                        }
                                    }else{
                                        chatTitleName = decryptedName
                                    }
                                }
                            }else{
                                chatTitleName = decryptedName
                            }
                                
                            if showGroupMembersNameAsgroupName{
                                let sortedArray = nameArr.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare(($1 as AnyObject) as! String) == ComparisonResult.orderedAscending }
                                let usersNameArray1:NSMutableArray = []
                                usersNameArray1.addObjects(from: sortedArray)
                                chatTitleName = usersNameArray1.componentsJoined(by: ",")
                            }
                            if chatTitleName == ""{
                                chatTitleName = "Untitled Chat"
                            }
                            var decryptedMessage = ""
                            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:contactsData["lastmsg"] as? String ?? "")

                            decryptedSeen = FirebaseService.instance.decryptTextMethod(text:contactsData["seen"] as? String ?? "")

                            var decryptedMsgType = ""
                            decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:contactsData["message_type"] as? String ?? "")

                            var decryptedProfilePic = ""
                            decryptedProfilePic = FirebaseService.instance.decryptTextMethod(text:contactsData["profile_pic"] as? String ?? "")

                            var decryptedKnownAs = ""
                            decryptedKnownAs = FirebaseService.instance.decryptTextMethod(text:contactsData["knownAs"] as? String ?? "")

                            let atWork = FirebaseService.instance.decryptTextMethod(text:contactsData["online"] as? String ?? "")

                            let decryptIsMute = FirebaseService.instance.decryptTextMethod(text:contactsData["ismute"] as? String ?? "1".encryptMessage() ?? "")

                            let decryptIsMsgSeenByReceiver = FirebaseService.instance.decryptTextMethod(text:contactsData["isMsgSeenByReceiver"] as? String ?? "".encryptMessage() ?? "")


                            conversation = ChatConversation(seen: decryptedSeen, emp_id: empid, isfavorite: contactsData["isfavorite"] as? Bool ?? false, lastmsg: decryptedMessage , isarchived: contactsData["isarchived"] as? Bool ?? false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: timestamp, isgroup: true, name: chatTitleName, message_type: decryptedMsgType, online: atWork, toChatId: contactsData["toChatId"] as? String ?? "", isread: contactsData["isread"] as? Bool ?? false, ismute: decryptIsMute, profile_pic: decryptedProfilePic, from_id: contactsData["from_id"] as? String ?? "", isMsgSeenByReceiver: decryptIsMsgSeenByReceiver, knownAs: decryptedKnownAs, usersDetailsArr: contactsData["usersDetailsArr"] as? [Any] ?? [], isGroupTitle: contactsData["isgroup_title"] as? Bool ?? false, isremoved: contactsData["isremoved"] as? Bool ?? false, message_key: contactsData["message_key"] as? String)
                                
                           

                            let unreadCount = decryptedSeen
                            if unreadCount != "" && unreadCount != "0"{
                                if contactsData["emp_id"] != nil{
                                    unreadCountStr += 1
                                }
                            }
                        }
                    }else{
                        var decryptedSeen = ""

                        if contactsData["emp_id"] != nil{
                            let empid = FirebaseService.instance.decryptTextMethod(text:contactsData["emp_id"] as? String ?? "")
                            let timestamp = contactsData["timestamp"] as? NSNumber ?? 0

                            var decryptedName = ""
                            decryptedName = FirebaseService.instance.decryptTextMethod(text:contactsData["name"] as? String ?? "")

                            var decryptedMessage = ""
                            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:contactsData["lastmsg"] as? String ?? "")

                            decryptedSeen = FirebaseService.instance.decryptTextMethod(text:contactsData["seen"] as? String ?? "")

                            var decryptedMsgType = ""
                            decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:contactsData["message_type"] as? String ?? "")

                            var decryptedProfilePic = ""
                            decryptedProfilePic = FirebaseService.instance.decryptTextMethod(text:contactsData["profile_pic"] as? String ?? "")

                            var decryptedKnownAs = ""
                            decryptedKnownAs = FirebaseService.instance.decryptTextMethod(text:contactsData["knownAs"] as? String ?? "")

                            let atWork = FirebaseService.instance.decryptTextMethod(text:contactsData["online"] as? String ?? "")

                            let decryptIsMute = FirebaseService.instance.decryptTextMethod(text:contactsData["ismute"] as? String ?? "false".encryptMessage() ?? "")

                            let decryptIsMsgSeenByReceiver = FirebaseService.instance.decryptTextMethod(text:contactsData["isMsgSeenByReceiver"] as? String ?? "".encryptMessage() ?? "")

                            conversation = ChatConversation(seen: decryptedSeen, emp_id: empid, isfavorite: contactsData["isfavorite"] as? Bool ?? false, lastmsg: decryptedMessage , isarchived: contactsData["isarchived"] as? Bool ?? false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: timestamp, isgroup: false, name: decryptedName, message_type: decryptedMsgType, online: atWork, toChatId: contactsData["toChatId"] as? String ?? "", isread: contactsData["isread"] as? Bool ?? false, ismute: decryptIsMute, profile_pic: decryptedProfilePic, from_id: contactsData["from_id"] as? String, isMsgSeenByReceiver: decryptIsMsgSeenByReceiver, knownAs: decryptedKnownAs, usersDetailsArr: contactsData["usersDetailsArr"] as? [Any] ?? [], isGroupTitle: contactsData["isgroup_title"] as? Bool ?? false, isremoved: contactsData["isremoved"] as? Bool ?? false, message_key: contactsData["message_key"] as? String)
                                
                            
                        }
                        let unreadCount = decryptedSeen
                        if unreadCount != "" && unreadCount != "0"{
                            if contactsData["emp_id"] != nil{
                                unreadCountStr += 1
                            }

                        }
                    }
                }
            }
        if conversation != nil{
            completion(conversation)
        }
//        }
    }
    
    
    // MARK: - fireBase chat Methods
    
    
    func loadAllMessages(completion: @escaping ([Message],[String]) -> ())
    {
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        var allMessagesKeyArr: [String] = []
        
        messageRefSenderTestForSingle = firebaseService.databaseMessages().child(currentUserId as! String).child(toUsreId as! String)
        messageRefSenderTestForSingle.keepSynced(true)
        messageRefSenderTestForSingle.observe(.childAdded) { (snapshot) in
            print("childAdded in loadallmessages in new chat view model")
            if !snapshot.exists() { completion(self.allMessages,allMessagesKeyArr) }
            allMessagesKeyArr.append(snapshot.key)
            let messageData = snapshot.value as? [String: Any]

            var deliveryStatus =  ""
            var deliveryStatusEncrypted = messageData?["deliverd_status"] as? String ?? ""
//            deliveryStatus = FirebaseService.instance.decryptTextMethodWithFixedIV(text:messageData?["deliverd_status"] as? String ?? "")
            if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 {
                deliveryStatus = "1"
            }
            if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 {
                deliveryStatus = "2"
            }
            if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 {
                deliveryStatus = "3"
            }
            if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 {
                deliveryStatus = "4"
            }
            
            /////Update status as read
            let MessageKeyReadReferanece = self.firebaseService.databaseMessages().child(toUsreId as! String).child(currentUserId as! String).child(snapshot.key)
            let isFileUploadStatusVar = messageData?["isFileUploadedOnAWS"] as? Bool ?? false
            if isFileUploadStatusVar{
                if deliveryStatus != "3" || deliveryStatus != encryptedKeys.deliveryStatus3{
                    let messageDeliveryStatus = ["deliverd_status": encryptedKeys.deliveryStatus3] as [String : Any]
                    MessageKeyReadReferanece.updateChildValues(messageDeliveryStatus)
                }
            }
            
            ///get all messages once
            let isSeeen = messageData?["seen"] as? Bool ?? true

            var decryptedMsgType = ""
            decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData?["message_type"] as? String ?? "")

            let receivedMessage = messageData?["payload"] as? String
            var decryptedMessage = ""
            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

            var decryptedFromName = ""
            decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageData?["from_name"] as? String ?? "")

            var mediaInfo1 = ""
            mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData?["mediaInfo1"] as? String ?? "")

            var mediaInfo2 = ""
            mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData?["mediaInfo2"] as? String ?? "")

            if messageData?["timeStamp"] as? NSNumber != nil{
                let message:Message = Message(timeStamp: messageData?["timeStamp"] as? NSNumber ?? 0, from_id: messageData?["from_id"] as? String ?? "", from_name: decryptedFromName, payload: decryptedMessage , mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData?["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData?["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: snapshot.key)
                self.allMessages.append(message)
                self.allMessages = self.allMessages.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })

            }
            
            completion(self.allMessages,allMessagesKeyArr)
        }
        
        
        messageRefSenderTestChildChangedForSingle = firebaseService.databaseMessages().child(currentUserId as! String).child(toUsreId as! String)
        messageRefSenderTestChildChangedForSingle.keepSynced(true)
        messageRefSenderTestChildChangedForSingle.observe(.childChanged) { (snapshot) in
            print("ChildChanged in loadallmessages in new chat view model")
            if !snapshot.exists() { }
            let messageData = snapshot.value as? [String: Any]
            /////Update status as read
            let MessageKeyReadReferaneceChildChanged = self.firebaseService.databaseMessages().child(toUsreId as! String).child(currentUserId as! String).child(snapshot.key)
            let isFileUploadStatusVar = messageData?["isFileUploadedOnAWS"] as? Bool ?? false
            if isFileUploadStatusVar{
                let messageDeliveryStatus = ["deliverd_status": encryptedKeys.deliveryStatus3] as [String : Any]
                MessageKeyReadReferaneceChildChanged.updateChildValues(messageDeliveryStatus)
            }
        }
    }
        
    func loadAllMessagesPagination(scrollToTop:Int, completion: @escaping ([Date:[Message]],[Date],[Message],[String]) -> ())
    {
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        var messageKeyArr: [String] = []
        var messageSentStatusArr: [String] = []
        messageRefSenderPagingForSingle = firebaseService.databaseMessages().child(currentUserId as? String ?? "").child(toUsreId as! String)
        messageRefSenderPagingForSingle.keepSynced(true)
        messageRefSenderPagingForSingle.queryLimited(toLast: UInt(scrollToTop)).observe(.value) { (snapshot) in
            if !snapshot.exists() { completion(self.msgDateDict,self.dateKeysArr,self.messages,messageKeyArr) }
            print("scrollToTop value in loadAllMessagesPagination in new chat view model")
            self.messages.removeAll()
            messageKeyArr.removeAll()
            messageSentStatusArr.removeAll()
            self.dateKeysArr.removeAll()
            self.msgDateDict.removeAll()
            
            let messageSenderDict = snapshot.value as? [String: Any]
            for(key,value) in messageSenderDict ?? [:] {
                messageKeyArr.append(key)
                if let messageData = value as? [String:Any]{
                    let isSeeen = messageData["seen"] as? Bool ?? true //messageData["seen"] as? String ?? "true"
                    let msgFromId = messageData["from_id"] as? String ?? ""
                    let isFileUploadStatusVar = messageData["isFileUploadedOnAWS"] as? Bool ?? false
                    
                    var deliveryStatus =  ""
                    var deliveryStatusEncrypted = messageData["deliverd_status"] as? String ?? ""
                    
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                        deliveryStatus = "1"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                        deliveryStatus = "2"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                        deliveryStatus = "3"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                        deliveryStatus = "4"
                    }
                    
                    ////if msg is for receiver side and not added on AWS then do not add that to message list....for sender side add all msgs to messages list either it iploaded to AWs or not
                    if msgFromId != currentUserId as? String{
                        if isFileUploadStatusVar{
                            if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil {
                                var decryptedMsgType = ""
                                decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")

                                let receivedMessage = messageData["payload"] as? String
                                var decryptedMessage = ""
                                decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                                var decryptedFromName = ""
                                decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")

                                var mediaInfo1 = ""
                                mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                                var mediaInfo2 = ""
                                mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")

                                
                                let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptedFromName, payload: decryptedMessage , mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                                self.messages.append(message)
                                self.messages = self.messages.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })
                            }
                        }
                    }else{
                        if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                            var decryptedMsgType = ""
                            decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")

                            let receivedMessage = messageData["payload"] as? String
                            var decryptedMessage = ""
                            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")
                            
                            var decryptedFromName = ""
                            decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")
                            
                            var mediaInfo1 = ""
                            mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                            var mediaInfo2 = ""
                            mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")


                            let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptedFromName, payload: decryptedMessage , mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                            self.messages.append(message)
                            self.messages = self.messages.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })
                        }
                    }

                    messageSentStatusArr.append(deliveryStatus)
                }
            }

            let dateArray = Set(self.messages.map{($0.message_dateStr)})
            for dateObjStr in dateArray{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let dateObj1 = dateFormatter.date(from: dateObjStr)

                if dateObj1 != nil{
                    self.msgDateDict[dateObj1!] = self.messages.filter{($0.message_dateStr == dateObjStr)}.sorted(by: { (msg1, msg2) -> Bool in
                        let date1 = Date(timeIntervalSince1970: Double(truncating: msg1.timeStamp!))
                        let date2 = Date(timeIntervalSince1970: Double(truncating: msg2.timeStamp!))
                        return date1 < date2
                    })
                }
                
            }
            
            self.dateKeysArr = Array(self.msgDateDict.keys).sorted()
            completion(self.msgDateDict,self.dateKeysArr,self.messages,messageKeyArr)
        }
    }
    
    func loadAllMessagesGroups(completion: @escaping ([Message],[String]) -> ()){
        
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        
        
        messageRefSenderForGroup = firebaseService.databaseMessages().child("Groups").child(toUsreId as! String)
        messageRefSenderForGroup.keepSynced(true)
        var allMessageKeyArr: [String] = []
        var allMessageArr: [Message] = []
//        messageRefSenderForGroup.observe(.childAdded){ (snapshot) in
            messageRefSenderForGroup.observeSingleEvent(of: .childAdded){ (snapshot) in
            print("childAdded(new) in loadAllMessagesGroups in new chat view model")
            if !snapshot.exists() { completion(allMessageArr,allMessageKeyArr) }
            if  let messageDict = snapshot.value as? [String: Any]{
                allMessageKeyArr.append(snapshot.key )
                
                
                var seenMsgByMembers = ""
                var seenMsgByMembersArr:[String] = []
                let seenMsgByMembersValue = messageDict["seenMembers"] as? String ?? ""
                if seenMsgByMembersValue != ""{
                    seenMsgByMembersArr = seenMsgByMembersValue.components(separatedBy: ",")
                }
                if seenMsgByMembersArr.contains(currentUserId as? String ?? ""){
                }else{
                    seenMsgByMembersArr.append(currentUserId as? String ?? "")
                    
                    seenMsgByMembers = seenMsgByMembersArr.joined(separator: ",")

                    /////Update status as read
                    let MessageKeyReadReferanece = self.firebaseService.databaseMessages().child("Groups").child(toUsreId as! String).child(snapshot.key)
                    let isFileUploadStatusVar = messageDict["isFileUploadedOnAWS"] as? Bool ?? false
                    if isFileUploadStatusVar{
                        let messageDeliveryStatus = ["seenMembers": seenMsgByMembers] as [String : Any]
                        MessageKeyReadReferanece.updateChildValues(messageDeliveryStatus)
                    }
                }
                
                
                let isSeeen = messageDict["seen"] as? Bool ?? true  //messageSenderDict["seen"] as? String ?? "true"
                if messageDict["timeStamp"] as? NSNumber != nil{
                    var decryptedMsgType = ""
                    decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageDict["message_type"] as? String ?? "")

                    let receivedMessage = messageDict["payload"] as? String
                    var decryptedMessage = ""
                    decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                    var decryptedFromName = ""
                    decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageDict["from_name"] as? String ?? "")

                    var mediaInfo1 = ""
                    mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageDict["mediaInfo1"] as? String ?? "")

                    var mediaInfo2 = ""
                    mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageDict["mediaInfo2"] as? String ?? "")

                    var deliveryStatus =  ""
                    var deliveryStatusEncrypted = messageDict["deliverd_status"] as? String ?? ""
                    
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                        deliveryStatus = "1"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                        deliveryStatus = "2"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                        deliveryStatus = "3"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                        deliveryStatus = "4"
                    }
                    
                    let message:Message = Message(timeStamp: messageDict["timeStamp"] as? NSNumber ?? 0, from_id: messageDict["from_id"] as? String ?? "", from_name: decryptedFromName, payload: decryptedMessage, mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageDict["seenMembers"] as? String ?? "" , message_type: decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageDict["isFileUploadedOnAWS"] as? Bool ?? true, messageKey:  snapshot.key)
                    allMessageArr.append(message)
                    allMessageArr = allMessageArr.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })
                }
                self.allMessagesGroups = allMessageArr
                completion(allMessageArr,allMessageKeyArr)
            }
        }
    }
 
    func loadAllMessagesGroupsPagination(scrollToTop:Int, completion: @escaping ([Date:[Message]],[Date],[Message],[String]) -> ()){
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        messageRefSenderPagingForGroup = firebaseService.databaseMessages().child("Groups").child(toUsreId as! String)
        messageRefSenderPagingForGroup.keepSynced(true)
        var messageKeyArr: [String] = []
            messageRefSenderPagingForGroup.queryLimited(toLast: UInt(scrollToTop)).observeSingleEvent(of: .value) { (snapshot) in
            print("scrollToTop value in loadAllMessagesGroupsPagination in new chat view model")
            if !snapshot.exists() { completion(self.msgDateDict,self.dateKeysArr,self.messages,messageKeyArr)  }
            self.messages.removeAll()
            messageKeyArr.removeAll()
            self.dateKeysArr.removeAll()
            self.msgDateDict.removeAll()
            
            let messageSenderDict = snapshot.value as? [String: Any]
            
            for(key,value) in messageSenderDict ?? [:] {
                messageKeyArr.append(key)
                if let messageData = value as? [String:Any]{
                    let isSeeen = messageData["seen"] as? Bool ?? true //messageData["seen"] as? String ?? "true"
                    let msgFromId = messageData["from_id"] as? String ?? ""
                    let isFileUploadStatusVar = messageData["isFileUploadedOnAWS"] as? Bool ?? false
                    
                    var deliveryStatus =  ""
                    var deliveryStatusEncrypted = messageData["deliverd_status"] as? String ?? ""
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                        deliveryStatus = "1"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                        deliveryStatus = "2"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                        deliveryStatus = "3"
                    }
                    if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                        deliveryStatus = "4"
                    }
                    
                    ////if msg is for receiver side and not added on AWS then do not add that to message list....for sender side add all msgs to messages list either it iploaded to AWs or not
                    if msgFromId != currentUserId as? String{
                        if isFileUploadStatusVar || msgFromId == "notifyMsg"{
                            if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                                var decryptedMsgType = ""
                                decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")

                                let receivedMessage = messageData["payload"] as? String
                                var decryptedMessage = ""
                                decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                                var decryptedFromName = ""
                                decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")
                                
                                var mediaInfo1 = ""
                                mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                                var mediaInfo2 = ""
                                mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")

                                
                                let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptedFromName, payload: decryptedMessage, mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                                self.messages.append(message)
                                self.messages = self.messages.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })
                            }
                        }
                    }else{
                        if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                            var decryptedMsgType = ""
                            decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")

                            let receivedMessage = messageData["payload"] as? String
                            var decryptedMessage = ""
                            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                            var decryptedFromName = ""
                            decryptedFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")

                            var mediaInfo1 = ""
                            mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                            var mediaInfo2 = ""
                            mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")

                            
                            let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptedFromName, payload:
                                decryptedMessage, mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                            self.messages.append(message)
                            self.messages = self.messages.sorted(by: { $0.timeStamp?.int64Value ?? 0 < $1.timeStamp?.int64Value ?? 0 })
                        }
                    }
                }
            }
            
            
            let dateArray = Set(self.messages.map{($0.message_dateStr)})
            for dateObjStr in dateArray{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let dateObj1 = dateFormatter.date(from: dateObjStr)
                
                if dateObj1 != nil{
                    self.msgDateDict[dateObj1!] = self.messages.filter{($0.message_dateStr == dateObjStr)}.sorted(by: { (msg1, msg2) -> Bool in
                        let date1 = Date(timeIntervalSince1970: Double(truncating: msg1.timeStamp!))
                        let date2 = Date(timeIntervalSince1970: Double(truncating: msg2.timeStamp!))
                        return date1 < date2
                    })
                }
                
            }
            self.dateKeysArr = Array(self.msgDateDict.keys).sorted()
            
            completion(self.msgDateDict,self.dateKeysArr,self.messages,messageKeyArr)
        }
    }
    
    func getGroupMembersOfGroup(completion: @escaping ([Any]) -> ())
    {
        guard let groupId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        let groupIdIs:String = groupId as? String ?? ""
        if !groupIdIs.isEmpty{
            let groupMemberRef = firebaseService.databaseGroupChat().child(currentUserId as! String).child(groupId as! String).child("group_Members")
            groupMemberRef.keepSynced(true)
            groupMemberRef.observe(.value) { (snapshot) in
                if snapshot.exists() {
                    print("value in getGroupMembersOfGroup in new chat view model")
                    self.groupMembers.removeAll()
                    self.groupMembers = []
                    for object in snapshot.value as! [NSDictionary] {
                        let memberDict:NSMutableDictionary = NSMutableDictionary()
                        for(key,vaule) in object {
                            memberDict.setObject(vaule, forKey: key as! NSCopying)
                        }
                        self.groupMembers.append(memberDict)
                    }
                    groupMemberRef.removeAllObservers()
                    completion(self.groupMembers)
                }else{
                    groupMemberRef.removeAllObservers()
                    completion(self.groupMembers)
                }
            }
        }
    }

    func getGroupMembersOfGroupForAddpeople(completion: @escaping ([Any]) -> ())
    {
        guard let groupId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        print("groupMemberRef in getGroupMembersOfGroupForAddpeople in new chat view model")
        let groupMemberRef = firebaseService.databaseGroupChat().child(currentUserId as! String).child(groupId as! String).child("group_Members")
        groupMemberRef.keepSynced(true)
        groupMemberRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("value in getGroupMembersOfGroupForAddpeople in new chat view model")
                self.groupMembers.removeAll()
                self.groupMembers = []
                
                for object in snapshot.value as! [NSDictionary] {
                    
                    let memberDict:NSMutableDictionary = NSMutableDictionary()
                    for(key,vaule) in object {
                        memberDict.setObject(vaule, forKey: key as! NSCopying)
                    }
                    self.groupMembers.append(memberDict)
                }
                completion(self.groupMembers)
            }
            groupMemberRef.removeAllObservers()
        }
    }
    
    //MARK: - Send Message Methods

    func sendMessage(msgToSend:String, userObject: ChatConversation?, messageType:String?, msgsCount:Int?, mediaInfo1:String, mediaInfo2: String,isFileUploadedOnAWS: Bool)
    {
        let loginUserID:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loginUserID == "" {
            return
        }
//        let firstNameIs = UserDefaults.standard.value(forKey: "FirstName") as! [String]
//        let userFullName = firstNameIs.first!.getFullName(lastName: (UserDefaults.standard.value(forKey: "LastName") as? [String])!)
        
        let userFullName = UserDefaults.standard.value(forKey: Constant.UserDefaultKeys.fullName) as! String
        
        guard let toUserId = UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
        var key = ""

        let messageToSend = msgToSend.trimmingCharacters(in: .whitespacesAndNewlines)
        if messageToSend == "" || messageToSend.isEmpty{
            return
        } else {
            print("single message : \(String(describing: messageToSend))")
            ///current userId
            var message: [String : Any]
            
            if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
            }else{
                if isFileUploadedOnAWS == true{
                    message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus2, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }else{
                    message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }
            }
            
            print("messageRef1 in sendMessage in new chat view model")
            let messageRef = firebaseService.databaseMessages().child(loginUserID as! String).child(toUserId).childByAutoId()
            messageRef.setValue(message)
            key = messageRef.key ?? ""
            
            
            ///new added for toUser Id
            var message1: [String : Any]
            if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                message1 = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": false, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
            }else{
                if isFileUploadedOnAWS == true{
                    message1 = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": false, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus2, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }else{
                    message1 = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": false, "message_type":messageType?.encryptMessage() ?? "", "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }
                
            }
            print("messageRef2 in sendMessage in new chat view model")
            let messageRef1 = firebaseService.databaseMessages().child(toUserId).child(loginUserID as! String).child(key)
            messageRef1.setValue(message1)
            
            if isFileUploadedOnAWS == true{
                self.callLastMsgAfterFileUploadedForSingle(loginUserID: loginUserID as! String , toUserId: toUserId, lastMsg:msgToSend, MsgType:messageType!, msgsCount:msgsCount!, key:key, isFileUploadedOnAWS:isFileUploadedOnAWS)
            }
        }
        
    }
    
    func callLastMsgAfterFileUploadedForSingle(loginUserID: String, toUserId: String, lastMsg: String, MsgType: String, msgsCount: Int, key: String, isFileUploadedOnAWS: Bool){

        ///send notification after message sending
        if Util.shared.checkInternetAndShowAlert() == true || isInternetlimitedAccessEnable{
            let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
            let notificationpayload = ["from": loginUserID, "type": "0", "companyId": companyId ?? ""] as [String : Any]
            print("notificationRef in sendMessage in new chat view model")
            let notificationRef = firebaseService.databaseNotification().child(toUserId).child(key)
            notificationRef.setValue(notificationpayload)
        }else{
            if MsgType != "image" && MsgType != "attachment" && MsgType != "audio" && MsgType != "video" && MsgType != "gif"{
                let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
                let notificationpayload = ["from": loginUserID, "type": "0", "companyId": companyId ?? ""] as [String : Any]
                print("notificationref2 in sendMessage in new chat view model")
                let notificationRef = firebaseService.databaseNotification().child(toUserId).child(key)
                notificationRef.setValue(notificationpayload)
            }
        }
        
        // UnArchive Conversation
//        let firstNameIs = UserDefaults.standard.value(forKey: "FirstName") as! [String]
//        let fromUserFullName = firstNameIs.first!.getFullName(lastName: (UserDefaults.standard.value(forKey: "LastName") as? [String])!)
        
        let fromUserFullName = UserDefaults.standard.value(forKey: Constant.UserDefaultKeys.fullName) as! String
        
        let fromEmpName = fromUserFullName
        
        guard let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") as? String else {return}
        
        guard let currentEmpID = UserDefaults.standard.value(forKey: "currentUserEmpID") as? String else{ return }
        
        guard let toEmpID = UserDefaults.standard.value(forKey: "ToEmployeeId") else{ return }
        
        self.unArchiveChatConv(currentUserId: loginUserID, toUserId: toUserId)
        
        if Util.shared.checkInternetAndShowAlert() == true || isInternetlimitedAccessEnable{
            self.getLastMessageOfConversationForSingleChat1(currentUserId: loginUserID , toUsreId: toUserId, toEmpName:toEmpName, toEmpId:"\(toEmpID)", lastMsg:lastMsg, MsgType:MsgType ,msgsCount:msgsCount, messageKey:key){ (success) in
                if success{
                }
            }
            self.getLastMessageOfConversationForSingleChat1(currentUserId: toUserId , toUsreId: loginUserID , toEmpName:fromEmpName, toEmpId:currentEmpID, lastMsg:lastMsg, MsgType:MsgType , msgsCount:msgsCount, messageKey:key){ (success) in
                if success{
                }
            }
        }else{
            if MsgType != "image" && MsgType != "attachment" && MsgType != "audio" && MsgType != "video" && MsgType != "gif"{
                self.getLastMessageOfConversationForSingleChat1(currentUserId: loginUserID , toUsreId: toUserId, toEmpName:toEmpName, toEmpId:"\(toEmpID)", lastMsg:lastMsg, MsgType:MsgType ,msgsCount:msgsCount, messageKey:key){ (success) in
                    if success{
                    }
                }
                
                self.getLastMessageOfConversationForSingleChat1(currentUserId: toUserId , toUsreId: loginUserID , toEmpName:fromEmpName, toEmpId:String(currentEmpID), lastMsg:lastMsg, MsgType:MsgType , msgsCount:msgsCount, messageKey:key){ (success) in
                    if success{
                    }
                }
            }
        }
        
    }
    
    func sendGroupMessage(allMentionedUUIDArrary:[Any], msgToSend:String, messageFor:String, actionPerformedOnUser:String, actionPerformedOnUserId:String, renamedGroupName:String, previousGroupName:String, groupMember:[Any], isNotifyMessage:String, messageType:String, mediaInfo1:String, mediaInfo2: String,isFileUploadedOnAWS: Bool, completion: @escaping(_ success: Bool) ->())
    {
        let loginUserID:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loginUserID == "" {
            print("current User id nil")
            return
        }
        
        let firstNameIs = UserDefaults.standard.value(forKey: "FirstName") as! [String]
        let userFullName = firstNameIs.first!.getFullName(lastName: (UserDefaults.standard.value(forKey: "LastName") as? [String])!)
        guard let toUserId = UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
        guard let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") as? String else {return}
        var key1 :String = ""

         
        let messageToSend = msgToSend.trimmingCharacters(in: .whitespacesAndNewlines)
        if messageToSend == "" || messageToSend == nil {
            return
        } else {
            // current Loing User
            print("messageToSend : \(String(describing: messageToSend))")
            
            if key1 == ""{
                print("generate key for msg in sendGroupMessage in new chat view model")
                let newMsgKeyRef = firebaseService.databaseMessages().child("Groups").child(toUserId).childByAutoId()
                key1 = newMsgKeyRef.key!
            }
            let message: [String : Any]
            var staticMessageString = ""

            if isNotifyMessage == "yes"{
                if messageFor == "createMsg"{
                    staticMessageString = "\(userFullName)~`created_this_conversation"
                }
                if messageFor == "addedMsg"{
                    staticMessageString = "\(userFullName)~`added~\(actionPerformedOnUser)~`to_this_conversation"
                }
                if messageFor == "removedMsg"{
                    staticMessageString = "\(userFullName)~`removed~\(actionPerformedOnUser)~`from_this_conversation"
                }
                if messageFor == "leftMsg"{
                    staticMessageString = "\(userFullName)~`left~`from_this_conversation"
                }
                if messageFor == "renameMsg"{
                    staticMessageString = "\(userFullName)~`renamed_from~\(previousGroupName)~`to~\(renamedGroupName)"
                }
                
                if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                    message = ["from_id": "notifyMsg", "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": staticMessageString.encryptMessage() ?? "", "seen": true, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }else{
                    message = ["from_id": "notifyMsg", "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": staticMessageString.encryptMessage() ?? "", "seen": true, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus2, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                }
            }else{
                if messageType == "video" || messageType == "audio" || messageType == "attachment"{
                    if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                        message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                    }else{
                        if isFileUploadedOnAWS == true{
                            message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus2, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                        }else{
                            message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "mediaInfo1": mediaInfo1.encryptMessage(), "mediaInfo2": mediaInfo2.encryptMessage(), "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                        }
                    }
                }else{
                    if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                        message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                    }else{
                        if isFileUploadedOnAWS == true{
                            message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus2, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                        }else{
                            message = ["from_id": loginUserID, "from_name": userFullName.encryptMessage(), "timeStamp": ServerValue.timestamp(), "payload": messageToSend, "seen": true, "seenMembers": loginUserID, "message_type":messageType.encryptMessage(), "deliverd_status": encryptedKeys.deliveryStatus1, "isFileUploadedOnAWS": isFileUploadedOnAWS] as [String : Any]
                        }
                    }
                }
            }
            let membersRef1 = self.firebaseService.databaseMessages().child("Groups").child(toUserId).child(key1)
            membersRef1.setValue(message)
            // Group Members
            for member in groupMember{
                let memberDict = member as? [String:Any]
                for(key,value) in memberDict ?? [:] {
                    if(key == "groupMemberId"){
                        guard let groupMemberId:String = value as? String else{return}
                        if !groupMemberId.isEmpty{
                            if isFileUploadedOnAWS == true{
                                self.callLastMsgUpdateAfterFileUploadForGroup(grpMemberId:groupMemberId, loginUserID:loginUserID, toEmpName:toEmpName, toUserId:toUserId, lastMsg:msgToSend, MsgType:messageType,  isNotifyMessage:isNotifyMessage, messageKey:key1, messageFor:messageFor, key1:key1, actionPerformedOnUserId:actionPerformedOnUserId, allMentionedUUIDArrary:allMentionedUUIDArrary)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    func callLastMsgUpdateAfterFileUploadForGroup(grpMemberId:String, loginUserID:String, toEmpName:String, toUserId:String?, lastMsg:String, MsgType:String, isNotifyMessage:String?, messageKey:String, messageFor:String, key1:String, actionPerformedOnUserId:String, allMentionedUUIDArrary:[Any]){
        
        
        if grpMemberId != loginUserID{
            if Util.shared.checkInternetAndShowAlert() == true || isInternetlimitedAccessEnable{
                let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
                let notificationpayload = ["from": loginUserID, "type": "0", "companyId": companyId ?? "", "MentionedUser":allMentionedUUIDArrary] as [String : Any]
                print("notificationRef if internet on in sendGroupMessage in new chat view model")
                let notificationRef = firebaseService.databaseNotification().child(toUserId!).child(key1)
                notificationRef.setValue(notificationpayload)
            }else{
                if MsgType != "image" && MsgType != "attachment" && MsgType != "audio" && MsgType != "video" && MsgType != "gif"{
                    let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
                    let notificationpayload = ["from": loginUserID, "type": "0", "companyId": companyId ?? "", "MentionedUser":allMentionedUUIDArrary] as [String : Any]
                    print("notificationRef if internet off and msgType(not media) in sendGroupMessage in new chat view model")
                    let notificationRef = firebaseService.databaseNotification().child(toUserId!).child(key1)
                    notificationRef.setValue(notificationpayload)
                }
            }
        }
        
        
        
        if Util.shared.checkInternetAndShowAlert() == true || isInternetlimitedAccessEnable{
            self.getLastMessageOfConversationForGroup1(grpMember:grpMemberId, groupName:toEmpName, lastMsg:lastMsg, MsgType:MsgType, isNotifyMessage:isNotifyMessage, messageKey:key1, messageFor: messageFor, actionPerformedOnUserId:actionPerformedOnUserId){ (success) in
                    if success{
                    }
                }
        }else{
            if MsgType != "image" && MsgType != "attachment" && MsgType != "audio" && MsgType != "video" && MsgType != "gif"{
                self.getLastMessageOfConversationForGroup1(grpMember:grpMemberId, groupName:toEmpName, lastMsg:lastMsg, MsgType:MsgType, isNotifyMessage:isNotifyMessage, messageKey:key1, messageFor: messageFor, actionPerformedOnUserId:actionPerformedOnUserId){ (success) in
                    if success{
                    }
                }
            }
        }
    }
    
    func unArchiveChatConv(currentUserId:String, toUserId: String)
    {
        // Sendar
        print("messageRefSender1 in unArchiveChatConv(currentUserId:String, toUserId: String) in new chat view model")
        let messageRefSender1 = firebaseService.databaseChats1().child(currentUserId ).child(toUserId )
        messageRefSender1.keepSynced(true)
        messageRefSender1.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if  let messageDict = snapshot.value as? [String: Any]{
                    print("chatConvRef in unArchiveChatConv(currentUserId:String, toUserId: String) in new chat view model")
                    let chatConvRef = self.firebaseService.databaseChats1().child(currentUserId ).child(toUserId )
                    
                    chatConvRef.updateChildValues(["emp_id": messageDict["emp_id"],
                                                   "isarchived": false,
                                                   "isfavorite": messageDict["isfavorite"] as? Bool,
                                                   "isgroup":messageDict["isgroup"] as? Bool,
                                                   "lastmsg":messageDict["lastmsg"],
                                                   "message_type":messageDict["message_type"],
                                                   "name":messageDict["name"],
                                                   "seen":messageDict["seen"],
                                                   "timestamp":messageDict["timestamp"],
                                                   "toChatId":messageDict["toChatId"],
                                                   "isread": messageDict["isread"] as? Bool,
                                                   "online":messageDict["online"],
                                                   "ismute":messageDict["ismute"],
                                                   "profile_pic":messageDict["profile_pic"] ?? "",
                                                   "from_id":messageDict["from_id"],
                                                   "isMsgSeenByReceiver":messageDict["isMsgSeenByReceiver"] ?? "",
                                                   "knownAs": messageDict["knownAs"] as? String ?? "",
                                                   "usersDetailsArr": messageDict["usersDetailsArr"],
                                                   "isgroup_title": messageDict["isgroup_title"]
                                                   ] as [String : Any?] as [AnyHashable : Any])
                    
                }
            }
            messageRefSender1.removeAllObservers()
        }
        
        //Reciever
        print("messageRefReceiver1 in unArchiveChatConv(currentUserId:String, toUserId: String) in new chat view model")
        let messageRefReceiver1 = firebaseService.databaseChats1().child(toUserId ).child(currentUserId )
        messageRefReceiver1.keepSynced(true)
        messageRefReceiver1.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                if  let messageDict = snapshot.value as? [String: Any]{
                    print("chatConvReceiver in unArchiveChatConv(currentUserId:String, toUserId: String) in new chat view model")
                    let chatConvReceiver = self.firebaseService.databaseChats1().child(toUserId ).child(currentUserId )
                    
                    chatConvReceiver.updateChildValues(["emp_id": messageDict["emp_id"],
                                                   "isarchived": false,
                                                   "isfavorite": messageDict["isfavorite"] as? Bool,
                                                   "isgroup":messageDict["isgroup"] as? Bool,
                                                   "lastmsg":messageDict["lastmsg"],
                                                   "message_type":messageDict["message_type"],
                                                   "name":messageDict["name"],
                                                   "seen":messageDict["seen"],
                                                   "timestamp":messageDict["timestamp"],
                                                   "toChatId":messageDict["toChatId"],
                                                   "isread": messageDict["isread"] as? Bool,
                                                   "online":messageDict["online"],
                                                   "ismute":messageDict["ismute"],
                                                   "profile_pic":messageDict["profile_pic"] ?? "",
                                                   "from_id":messageDict["from_id"],
                                                   "isMsgSeenByReceiver":messageDict["isMsgSeenByReceiver"] ?? "",
                                                   "knownAs": messageDict["knownAs"] as? String ?? "",
                                                   "usersDetailsArr": messageDict["usersDetailsArr"],
                                                   "isgroup_title": messageDict["isgroup_title"]
                                                   ] as [String : Any?] as [AnyHashable : Any])

                }
            }
            messageRefReceiver1.removeAllObservers()
        }
    }
        
    
    func getLastMessageOfConversationForGroup1(grpMember:String, groupName:String?, lastMsg:String, MsgType:String, isNotifyMessage:String?, messageKey:String, messageFor:String, actionPerformedOnUserId:String, completion: @escaping(_ success: Bool) ->()){
        
        let groupMemberId = grpMember
        var isRead:Bool = false
        //guard let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentFireUserId") as? String else {return}
        let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loggedInUserId == "" {
            print("current User id nil")
            return
        }
        if loggedInUserId == groupMemberId{
            isRead = true
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        
        var seenCount:String = "0"
        var chatconvDict: [String: Any] = [:]
        let conversationRef = self.firebaseService.databaseChats1().child(groupMemberId ).child(toUsreId as! String )
        conversationRef.keepSynced(true)
        conversationRef.observeSingleEvent(of: .value){
            (snapshot) in
            if snapshot.exists() {
                print("chatConversationRef to get seenCount in getLastMessageOfConversationForGroup1 in new chat view model")
                if  let messageDict = snapshot.value as? [String: Any]{
                    chatconvDict = messageDict
                    
                    if loggedInUserId != groupMemberId{
                        var seenCounofToChatconvDict2:Int = Int(FirebaseService.instance.decryptTextMethod(text:chatconvDict["seen"] as? String ?? "")) ?? 0
                        seenCounofToChatconvDict2 += 1
                        seenCount = String(seenCounofToChatconvDict2)
                    }
                }
            }
            conversationRef.removeAllObservers()
        }
        
        let messageRefSender1 = firebaseService.databaseMessages().child("Groups").child(toUsreId as! String)
        let senderQuery = messageRefSender1.queryLimited(toLast: 1)
        senderQuery.observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.exists() {
                print("lastMessageRefOfGroupMember in getLastMessageOfConversationForGroup1 in new chat view model")
                let lastMessageRef = self.firebaseService.databaseChats1().child(groupMemberId ).child(toUsreId as! String)
                
                var chat:[String : Any] = [:]
                if isNotifyMessage == "yes"{
                    if messageFor == "removedMsg" ||  messageFor == "leftMsg"{
                        if actionPerformedOnUserId == groupMemberId{
                            chat = ["isarchived": true, "isfavorite": false , "timestamp": ServerValue.timestamp(), "lastmsg":lastMsg ,"message_type":MsgType.encryptMessage(), "message_key" : messageKey, "isremoved": true] as [String : Any] as [String : Any]
                        }else{
                            chat = ["timestamp": ServerValue.timestamp(), "lastmsg":lastMsg ,"message_type":MsgType.encryptMessage(), "message_key" : messageKey] as [String : Any] as [String : Any]
                        }
                    }else{
                        chat = ["isarchived": false, "timestamp": ServerValue.timestamp(), "lastmsg":lastMsg ,"message_type":MsgType.encryptMessage(), "message_key" : messageKey] as [String : Any] as [String : Any]
                    }
                }else{
                    chat = ["seen": seenCount, "isarchived": false, "timestamp": ServerValue.timestamp(), "lastmsg":lastMsg , "message_type":MsgType.encryptMessage(),"name":groupName?.encryptMessage() ?? "",  "toChatId":toUsreId, "isread": isRead, "message_key" : messageKey] as [String : Any] as [String : Any]
                }
                
                lastMessageRef.updateChildValues(chat)
                completion(true)
            }else{
                completion(false)
            }
            senderQuery.removeAllObservers()
        }
    }
    
    func getLastMessageOfConversationForSingleChat1(currentUserId:String, toUsreId:String, toEmpName:String, toEmpId:String, lastMsg:String, MsgType:String, msgsCount:Int?, messageKey:String, completion: @escaping(_ success: Bool) ->()){
        
        let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loggedInUserId == "" {
            print("current User id nil")
            return
        }
        
        if !currentUserId.isEmpty{
            var seenCount:String = "1"
            var chatconvDict: [String: Any] = [:]
            print("conversationRef in getLastMessageOfConversationForSingleChat1 in new chat view model")
            let conversationRef = self.firebaseService.databaseChats1().child(currentUserId ).child(toUsreId )
            conversationRef.keepSynced(true)
            conversationRef.observe(.value){
                (snapshot) in
                if snapshot.exists() {
                    if  let messageDict = snapshot.value as? [String: Any]{
                        chatconvDict = messageDict
                        
                        if loggedInUserId != currentUserId{
                            var seenCounofToChatconvDict2:Int = Int(FirebaseService.instance.decryptTextMethod(text:chatconvDict["seen"] as? String ?? "")) ?? 0
                            seenCounofToChatconvDict2 += 1
                            seenCount = String(seenCounofToChatconvDict2)
                        }
                    }
                }
                else{
                   seenCount = "1"
                }
                conversationRef.removeAllObservers()
            }
            
            var isRead:Bool = false
            var isMsgSeenByReceiverFlag = "3"
            if loggedInUserId == currentUserId{
                isRead = true
                seenCount = "0"
                if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                    isMsgSeenByReceiverFlag = "1"
                }else{
                    isMsgSeenByReceiverFlag = "2"
                }
            }

            print("messageRefSender1 in getLastMessageOfConversationForSingleChat1 in new chat view model")
            let messageRefSender1 = firebaseService.databaseMessages().child(currentUserId ).child(toUsreId )
            let senderQuery = messageRefSender1.queryLimited(toLast: 1)
            senderQuery.observeSingleEvent(of: .childAdded) { (snapshot) in
                if snapshot.exists() {
                    print("lastMessageRef in getLastMessageOfConversationForSingleChat1 in new chat view model")
                    let lastMessageRef = self.firebaseService.databaseChats1().child(currentUserId ).child(toUsreId )
                    
                    ////Added for last msg not updationg after sending msg
                    if msgsCount ?? 0 > 0{
                        let chat = ["emp_id": toEmpId.encryptMessage(), "isarchived": false, "isfavorite": chatconvDict["isfavorite"] ?? false, "isgroup": chatconvDict["isgroup"] ?? false, "lastmsg":lastMsg , "message_type":MsgType.encryptMessage(), "name":toEmpName.encryptMessage(), "seen": seenCount, "timestamp":ServerValue.timestamp(), "toChatId":toUsreId, "isread": isRead, "online":chatconvDict["online"] ?? "", "ismute":chatconvDict["ismute"] ?? "false".encryptMessage(), "profile_pic":chatconvDict["profile_pic"] ?? "", "from_id":loggedInUserId, "isMsgSeenByReceiver": isMsgSeenByReceiverFlag.encryptMessage(), "knownAs": chatconvDict["knownAs"] ?? "",
                                    "usersDetailsArr": chatconvDict["usersDetailsArr"] ?? [],"isgroup_title": chatconvDict["isgroup_title"] ?? false, "message_key" : messageKey] as [String : Any]
                            lastMessageRef.updateChildValues(chat)
                    }else{/////For setting online and profile pic, userdetails  initially
                        
                        let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
                        if loggedInUserId == "" {
                            print("current User id nil")
                            return
                        }
                        
                        if currentUserId == loggedInUserId as? String ?? ""{
                            let checkOnlineStatusWhenComingFromNewChat: Bool = UserDefaults.standard.bool(forKey: "FirToOnline")
                            let checkProfilePicWhenComingFromNewChat = UserDefaults.standard.value(forKey: "FirToProfileImg") as? String ?? ""
                            
                            var knownAsStr = ""

                            let predicate = NSPredicate(format:"employeeId = %ld", Int64(toEmpId) ?? "")
                            let employeeList = [String]() //sss employee details
                            if employeeList.count > 0
                            {
                                knownAsStr = ""
                            }
                            ///Added for setting group mamber name,knownas and id in chat converasation table to search and update id value changed
                            var usersDetailsArr:Array = [Any]()
                            let groupDict1:NSMutableDictionary = [:]
                            groupDict1.setValue(toUsreId, forKey: "memberId")
                            groupDict1.setValue(toEmpName.encryptMessage(), forKey: "name")
                            groupDict1.setValue(knownAsStr.encryptMessage(), forKey: "knownAs")
                            usersDetailsArr.append(groupDict1)
                            
                            let chat = ["emp_id": toEmpId.encryptMessage(), "isarchived": false, "isfavorite": chatconvDict["isfavorite"] ?? false, "isgroup": chatconvDict["isgroup"] ?? false, "lastmsg":lastMsg , "message_type":MsgType.encryptMessage(), "name":toEmpName.encryptMessage(), "seen": seenCount, "timestamp":ServerValue.timestamp(), "toChatId":toUsreId, "isread": isRead, "online":String(checkOnlineStatusWhenComingFromNewChat).encryptMessage() , "ismute":chatconvDict["ismute"] ?? "false".encryptMessage(), "profile_pic":checkProfilePicWhenComingFromNewChat.encryptMessage() ?? "" , "from_id":loggedInUserId, "isMsgSeenByReceiver": isMsgSeenByReceiverFlag.encryptMessage(), "knownAs": knownAsStr.encryptMessage(), "usersDetailsArr": usersDetailsArr, "isgroup_title": chatconvDict["isgroup_title"] ?? false, "message_key" : messageKey] as [String : Any]
                            lastMessageRef.updateChildValues(chat)
                            
                            
                        }else{
                            var currentEmpProfilePic = ""
                            var knownAsStr = ""

                            let employeeList = [String]() //sss employeedetails
                            if employeeList.count > 0
                            {
                                currentEmpProfilePic = ""
                                knownAsStr = ""
                            }
                            ///Added for setting group mamber name,knownas and id in chat converasation table to search and update id value changed
                            var usersDetailsArr:Array = [Any]()
                            let groupDict1:NSMutableDictionary = [:]
                            groupDict1.setValue(toUsreId, forKey: "memberId")
                            groupDict1.setValue(toEmpName.encryptMessage(), forKey: "name")
                            groupDict1.setValue(knownAsStr.encryptMessage(), forKey: "knownAs")
                            usersDetailsArr.append(groupDict1)
                            
                            let chat = ["emp_id": toEmpId.encryptMessage(), "isarchived": false, "isfavorite": chatconvDict["isfavorite"] ?? false, "isgroup": chatconvDict["isgroup"] ?? false, "lastmsg":lastMsg , "message_type":MsgType.encryptMessage(), "name":toEmpName.encryptMessage(), "seen": seenCount, "timestamp":ServerValue.timestamp(), "toChatId":toUsreId, "isread": isRead, "online":"true".encryptMessage() , "ismute":chatconvDict["ismute"] ?? "false".encryptMessage(), "profile_pic": currentEmpProfilePic.encryptMessage() , "from_id":loggedInUserId, "isMsgSeenByReceiver": isMsgSeenByReceiverFlag.encryptMessage(), "knownAs": knownAsStr.encryptMessage(), "usersDetailsArr": usersDetailsArr, "isgroup_title": chatconvDict["isgroup_title"] ?? false, "message_key" : messageKey] as [String : Any]
                            lastMessageRef.updateChildValues(chat)
                        }
                        
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            }
            senderQuery.removeAllObservers()
        }
    }
 
    //MARK: - Edit Delete message Method

    func editMessage(msgToSend:String,existingMsg:Message, isEdit:Bool, lastMsgKeyFromChatTable:String){
        //guard let loginUserID = UserDefaults.standard.value(forKey: "currentFireUserId") else{return}
        let loginUserID:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loginUserID == "" {
            print("current User id nil")
            return
        }
        guard let toUserId = UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}

        if isEdit{
            let messageToSend = msgToSend.trimmingCharacters(in: .whitespacesAndNewlines)
            if messageToSend == "" || messageToSend.isEmpty{
                return
            } else {
                print("edited message for single: \(String(describing: messageToSend))")
                var message: [String : Any]
                if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                    message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus1] as [String : Any]
                }else{
                    if existingMsg.isFileUploadedOnAWS == true{
                        message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus2] as [String : Any]
                    }else{
                        message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus1] as [String : Any]
                    }
                }
                let currentUserMessageRef = firebaseService.databaseMessages().child(toUserId).child(loginUserID as! String).child(existingMsg.messageKey!)
                currentUserMessageRef.updateChildValues(message)
                let toUserMessageRef = firebaseService.databaseMessages().child(loginUserID as! String).child(toUserId ).child(existingMsg.messageKey!)
                toUserMessageRef.updateChildValues(message)
            }
        }else{
            let currentUserMessageRef = firebaseService.databaseMessages().child(toUserId).child(loginUserID as! String).child(existingMsg.messageKey!)
            currentUserMessageRef.removeValue()
            let toUserMessageRef = firebaseService.databaseMessages().child(loginUserID as! String).child(toUserId ).child(existingMsg.messageKey!)
            toUserMessageRef.removeValue()
 ///sss
//            UIApplication.topViewController()?.showToast(message: Constant.AlertMessages.messageDeleted.localizedString)

            var lastMsg:Message?
            let lastMessageReferance = firebaseService.databaseMessages().child(loginUserID as! String).child(toUserId ).queryLimited(toLast: 1)
            lastMessageReferance.queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
                if !snapshot.exists() {
                    let currentLastMessageRef = self.firebaseService.databaseChats1().child(loginUserID as! String).child(toUserId)
                    let currentLastMessageRefToReceiver = self.firebaseService.databaseChats1().child(toUserId).child(loginUserID as! String)
                    let chat = ["lastmsg":"", "message_type":"", "seen": "", "message_key" : ""] as [String : Any]
                    currentLastMessageRef.updateChildValues(chat)
                    currentLastMessageRefToReceiver.updateChildValues(chat)
                }
                
                let messageDict = snapshot.value as? [String: Any]
                for(key,value) in messageDict ?? [:] {
                    if let messageData = value as? [String:Any]{
                        let isSeeen = messageData["seen"] as? Bool ?? true
                        let isFileUploadStatusVar = messageData["isFileUploadedOnAWS"] as? Bool ?? false
                        if isFileUploadStatusVar{
                            if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                                let receivedMessage = messageData["payload"] as? String

                                let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: messageData["from_name"] as? String ?? "", payload: receivedMessage ?? "", mediaInfo1: messageData["mediaInfo1"] as? String ?? "", mediaInfo2: messageData["mediaInfo2"] as? String ?? "", seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  messageData["message_type"] as? String ?? "", deliverd_status: messageData["deliverd_status"] as? String ?? "", isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                                lastMsg = message
                                


                                //////Upadte Chat Table on msg delete i.e count, last msg(if last msg deleted), timestamp etc.
                                self.updateLastMessageOfConversationForSingleChat(currentUserId:loginUserID as? String ?? "", toUsreId:toUserId , lastMsg:lastMsg!, lastMsgStr:"", isEditMsg:false, existingMsg:existingMsg, lastMsgKeyFromChatTable:lastMsgKeyFromChatTable){ (success) in
                                    if success{
                                    }
                                }
                                self.updateLastMessageOfConversationForSingleChat(currentUserId:toUserId, toUsreId:loginUserID as! String, lastMsg:lastMsg!, lastMsgStr:"", isEditMsg:false, existingMsg:existingMsg, lastMsgKeyFromChatTable:lastMsgKeyFromChatTable){ (success) in
                                    if success{
                                    }
                                }
                            }else{
                                let currentLastMessageRef = self.firebaseService.databaseChats1().child(loginUserID as! String).child(toUserId)
                                let currentLastMessageRefToReceiver = self.firebaseService.databaseChats1().child(toUserId).child(loginUserID as! String)
                                let chat = ["lastmsg":"", "message_type":"", "seen": "", "message_key" : ""] as [String : Any]
                                currentLastMessageRef.updateChildValues(chat)
                                currentLastMessageRefToReceiver.updateChildValues(chat)
                            }
                        }
                    }
                }
                lastMessageReferance.removeAllObservers()
            }
        }
        
        ////if last msg editing or deleting
        if existingMsg.messageKey! == lastMsgKeyFromChatTable{
            if isEdit{
                self.updateLastMessageOfConversationForSingleChat(currentUserId:loginUserID as! String, toUsreId:toUserId, lastMsg:msgEmpty, lastMsgStr:msgToSend, isEditMsg:isEdit, existingMsg: existingMsg, lastMsgKeyFromChatTable:lastMsgKeyFromChatTable){ (success) in
                    if success{
                    }
                }
            }
        }
    }
    
    func updateLastMessageOfConversationForSingleChat(currentUserId:String, toUsreId:String, lastMsg:Message, lastMsgStr:String, isEditMsg:Bool, existingMsg:Message, lastMsgKeyFromChatTable:String, completion: @escaping(_ success: Bool) ->()){
        
        //guard let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentFireUserId") as? String else {return}
        let loggedInUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if loggedInUserId == "" {
            print("current User id nil")
            return
        }
        if currentUserId != ""{

            if isEditMsg{
                let currentLastMessageRef = self.firebaseService.databaseChats1().child(currentUserId).child(toUsreId)
                let toLastMessageRef = self.firebaseService.databaseChats1().child(toUsreId).child(currentUserId)
                let chat = ["lastmsg":lastMsgStr] as [String : Any]
                currentLastMessageRef.updateChildValues(chat)
                toLastMessageRef.updateChildValues(chat)
            }else{
                var seenCount:String = "0"
                var chatconvDict: [String: Any] = [:]
                let conversationRef = self.firebaseService.databaseChats1().child(currentUserId ).child(toUsreId )
                conversationRef.keepSynced(true)
                conversationRef.observeSingleEvent(of: .value){
                    (snapshot) in
                    if snapshot.exists() {
                    if  let messageDict = snapshot.value as? [String: Any]{
                        chatconvDict = messageDict
                                    
                        if loggedInUserId != currentUserId{
                            if isEditMsg{
                                let seenCounofToChatconvDict2:Int = Int(FirebaseService.instance.decryptTextMethod(text:chatconvDict["seen"] as? String ?? "")) ?? 0
                                seenCount = String(seenCounofToChatconvDict2)
                            }else{
                                let seenCounofToChatconvDict2:Int = Int(FirebaseService.instance.decryptTextMethod(text:chatconvDict["seen"] as? String ?? "")) ?? 0
                                seenCount = seenCounofToChatconvDict2 == 0 ? "" : String(seenCounofToChatconvDict2 - 1)
                                }
                            }
                        }
                        
                        let currentLastMessageRef = self.firebaseService.databaseChats1().child(currentUserId ).child(toUsreId )
                        var chat:[String : Any] = [:]
                        chat = ["lastmsg":lastMsg.payload, "message_type":lastMsg.message_type, "seen": seenCount, "timestamp":lastMsg.timeStamp, "message_key" : lastMsg.messageKey] as [String : Any]
                        currentLastMessageRef.updateChildValues(chat)

                    }
                    conversationRef.removeAllObservers()
                }
            }
        }
    }
    
        
    func editMessageForGroup(allMentionedUUIDArrary:[Any], groupMember:[Any], msgToSend:String, existingMsg:Message, isEdit:Bool, lastMsgKeyFromChatTable:String){
            
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            print("current User id nil")
            return
        }
        guard let toUserId = UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}

        if isEdit{
            let messageToSend = msgToSend.trimmingCharacters(in: .whitespacesAndNewlines)
            if messageToSend == "" || messageToSend.isEmpty{
                return
            } else {
                print("edited message for group: \(String(describing: messageToSend))")
                
                ////Update Message Table
                var message: [String : Any]
                if Util.shared.checkInternetAndShowAlert() == false || isInternetlimitedAccessEnable{
                    message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus1] as [String : Any]
                }else{
                    if existingMsg.isFileUploadedOnAWS == true{
                        message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus2] as [String : Any]
                    }else{
                        message = ["payload": messageToSend,"deliverd_status": encryptedKeys.deliveryStatus1] as [String : Any]
                    }
                }
                let editMsgRef = firebaseService.databaseMessages().child("Groups").child(toUserId).child(existingMsg.messageKey!)
                editMsgRef.updateChildValues(message)
                
                
                
                for member in groupMember{
                    let memberDict = member as? [String:Any]
                    for(key,value) in memberDict ?? [:] {
                        if(key == "groupMemberId"){
                        guard let groupMemberId:String = value as? String else{return}
                            if !groupMemberId.isEmpty{
                                ///Update Chat Table last msg if message that is you edit is last msg
                                if existingMsg.messageKey! == lastMsgKeyFromChatTable{
                                    if isEdit{
                                        let chat = ["lastmsg":msgToSend] as [String : Any]
                                        let chatRefForEdit = firebaseService.databaseChats1().child(groupMemberId).child(toUserId)
                                        chatRefForEdit.updateChildValues(chat)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else{
            if existingMsg.messageKey != nil{
                let seenMsgBygroupMembersValue = existingMsg.seenMembers
                if seenMsgBygroupMembersValue != ""{
                    let seenMsgByMembersArr = seenMsgBygroupMembersValue?.components(separatedBy: ",")

                    let deleteMsgRef = firebaseService.databaseMessages().child("Groups").child(toUserId ).child(existingMsg.messageKey!)
                    deleteMsgRef.removeValue()///delete msg after getting seen value of user from chat table depending on msg seen or not
//sss
//                    UIApplication.topViewController()?.showToast(message: Constant.AlertMessages.messageDeleted.localizedString)
                                
                    var lastMsg:Message?
                    let lastMessageReferance = firebaseService.databaseMessages().child("Groups").child(toUserId ).queryLimited(toLast: 1)
                    lastMessageReferance.queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
                        if !snapshot.exists() {return}
                        let messageDict = snapshot.value as? [String: Any]
                        for(key,value) in messageDict ?? [:] {
                            if let messageData = value as? [String:Any]{
                                let isSeeen = messageData["seen"] as? Bool ?? true
                                let isFileUploadStatusVar = messageData["isFileUploadedOnAWS"] as? Bool ?? false
                                if isFileUploadStatusVar{
                                    if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                                        var decryptedMsgType = ""
                                        decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")
                                        
                                        let receivedMessage = messageData["payload"] as? String
                                        var decryptedMessage = ""
                                        decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                                        /*if decryptedMsgType == "text" || decryptedMsgType == "group_message"  {
                                            decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")
                                        }else{
                                            decryptedMessage = receivedMessage ?? ""
                                        }*/
                                        var decryptetFromName = ""
                                        decryptetFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")

                                        var mediaInfo1 = ""
                                        mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                                        var mediaInfo2 = ""
                                        mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")

                                        var deliveryStatus =  ""
                                        var deliveryStatusEncrypted = messageData["deliverd_status"] as? String ?? ""
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                                            deliveryStatus = "1"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                                            deliveryStatus = "2"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                                            deliveryStatus = "3"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                                            deliveryStatus = "4"
                                        }
                                        
                                        let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptetFromName, payload: decryptedMessage, mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                                        lastMsg = message
                                    }
                                }else {
                                    
                                    if messageData["timeStamp"] as? NSNumber != nil && messageData["payload"] as? String != nil{
                                        var decryptedMsgType = ""
                                        decryptedMsgType = FirebaseService.instance.decryptTextMethod(text:messageData["message_type"] as? String ?? "")

                                        let receivedMessage = messageData["payload"] as? String
                                        var decryptedMessage = ""
                                        decryptedMessage = FirebaseService.instance.decryptTextMethod(text:receivedMessage ?? "")

                                        var decryptetFromName = ""
                                        decryptetFromName = FirebaseService.instance.decryptTextMethod(text:messageData["from_name"] as? String ?? "")

                                        var mediaInfo1 = ""
                                        mediaInfo1 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo1"] as? String ?? "")

                                        var mediaInfo2 = ""
                                        mediaInfo2 = FirebaseService.instance.decryptTextMethod(text:messageData["mediaInfo2"] as? String ?? "")

                                        var deliveryStatus =  ""
                                        var deliveryStatusEncrypted = messageData["deliverd_status"] as? String ?? ""
    //            deliveryStatus = FirebaseService.instance.decryptTextMethodWithFixedIV(text:messageData["deliverd_status"] as? String ?? "")
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                                            deliveryStatus = "1"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                                            deliveryStatus = "2"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                                            deliveryStatus = "3"
                                        }
                                        if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                                            deliveryStatus = "4"
                                        }
                                        
                                        let message:Message = Message(timeStamp: messageData["timeStamp"] as? NSNumber ?? 0, from_id: messageData["from_id"] as? String ?? "", from_name: decryptetFromName, payload: decryptedMessage, mediaInfo1: mediaInfo1, mediaInfo2: mediaInfo2, seen: isSeeen, seenMembers: messageData["seenMembers"] as? String ?? "" , message_type:  decryptedMsgType, deliverd_status: deliveryStatus, isFileUploadedOnAWS: messageData["isFileUploadedOnAWS"] as? Bool ?? true, messageKey: key)
                                        lastMsg = message
                                    }
                                }
                            }
                        }
                                    
                        for member in groupMember{
                            let memberDict = member as? [String:Any]
                            for(key,value) in memberDict ?? [:] {
                                if(key == "groupMemberId"){
                                    guard let groupMemberId:String = value as? String else{return}
                                    if !groupMemberId.isEmpty{
                                        let unreadChatCountRefer = FirebaseService.instance.databaseChats1().child(groupMemberId).child(toUserId)
                                        unreadChatCountRefer.keepSynced(true)
                                        unreadChatCountRefer.observeSingleEvent(of: .value) { (snapshotChat) in
                                            if !snapshotChat.exists() { return }
                                            if  let memberDict = snapshotChat.value as? [String: Any]{
                                                let unreadCount = FirebaseService.instance.decryptTextMethod(text:memberDict["seen"] as? String ?? "0")
                                                var unreadCountValueInt = Int(unreadCount)
                                                if unreadCountValueInt == nil{
                                                    unreadCountValueInt = 0
                                                }
                                                if let seenMsgByMembersArr2 = seenMsgByMembersArr{
                                                    if seenMsgByMembersArr2.contains(groupMemberId){
                                                    }else{
                                                        if unreadCountValueInt ?? 0 > 0{
                                                            unreadCountValueInt! -= 1
                                                        }
                                                    }
                                                }
                                            self.updateLastMessageOfConversationForGroupChat(groupMemberId:groupMemberId, toUsreId:toUserId, lastMsg:lastMsg!, isEditMsg:false, existingMsg:existingMsg, lastMsgKeyFromChatTable:lastMsgKeyFromChatTable, seenCount:String(unreadCountValueInt!))
                                            }
                                            unreadChatCountRefer.removeAllObservers()
                                        }
                                    }
                                }
                            }
                        }
                        lastMessageReferance.removeAllObservers()
                    }
                }
            }else{
                //sss
//                UIApplication.topViewController()?.showToast(message: "\(Constant.AlertMessages.erroDeletingMsg.localizedString).")
            }
            
        }
    }
    
    func updateLastMessageOfConversationForGroupChat(groupMemberId:String, toUsreId:String, lastMsg:Message, isEditMsg:Bool, existingMsg:Message, lastMsgKeyFromChatTable:String,seenCount:String){
        
        //guard let _:String =  UserDefaults.standard.value(forKey: "currentFireUserId") as? String else {return}
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            print("current User id nil")
            return
        }
        if !isEditMsg{
            let currentLastMessageRef = self.firebaseService.databaseChats1().child(groupMemberId ).child(toUsreId )
            if self.messages.count > 0{
                
                var chat:[String : Any] = [:]
                let lastMsgPayloadToSet = (lastMsg.payload)?.encryptMessage()
                if existingMsg.messageKey! == lastMsgKeyFromChatTable{
                    chat = ["lastmsg": lastMsgPayloadToSet, "message_type":lastMsg.message_type, "seen": seenCount, "timestamp":lastMsg.timeStamp ?? 0, "message_key" : lastMsg.messageKey] as [String : Any]
                    currentLastMessageRef.updateChildValues(chat)
                }else{
                    chat = ["lastmsg":lastMsgPayloadToSet, "message_type":lastMsg.message_type, "seen": seenCount, "timestamp":lastMsg.timeStamp ?? 0, "message_key" : lastMsg.messageKey] as [String : Any]
                   currentLastMessageRef.updateChildValues(chat)
                }
                
            }else{
                let chat = ["lastmsg":"", "message_type":"", "seen": seenCount] as [String : Any]
                currentLastMessageRef.updateChildValues(chat)
            }
        }
    }
    
    // MARK: - chatOptionView methods
    // for group options view
    
    func addGroupChatOptions(isFavourite:Bool?,isArchive:Bool?, isRead:Bool?, completion:@escaping ([ChatOptionTypeModel]) -> Void){
        var optionArray = [ChatOptionTypeModel]()
        
        optionArray.append(ChatOptionTypeModel(optionImage: "Add-people", optionName: "add people", cellType: .addPeople))
        optionArray.append(ChatOptionTypeModel(optionImage: "RemovePeopleFromChat", optionName: "remove people", cellType: .removePeople))
        optionArray.append(ChatOptionTypeModel(optionImage: "renameChatConversation", optionName: "rename conversation", cellType: .renameConversation))
        optionArray.append(ChatOptionTypeModel(optionImage: "Alerts", optionName: "notification setting", cellType: .notificationSetting))
        if isFavourite ?? false {
            optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as fvt", cellType: .markFavorite))
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as fvt", cellType: .markFavorite))
        }
        optionArray.append(ChatOptionTypeModel(optionImage: "unreadChatMsgs", optionName: "Mark as unread", cellType: .markUnread))

        if isArchive ?? false {
            optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "unarchive" , cellType: .archive))
            
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "Archive" , cellType: .archive))
        }
        optionArray.append(ChatOptionTypeModel(optionImage: "leave", optionName: "leave", cellType: .leave))
        optionArray.append(ChatOptionTypeModel(optionImage: "Report", optionName: "Report", cellType: .report))
        
        completion(optionArray)
    }
    // for single chat view
    func addChatOptions(isFavourite:Bool?,isArchive:Bool?, isUserMute: String?, isRead:Bool?, completion:@escaping ([ChatOptionTypeModel]) -> Void){
        
        var optionArray = [ChatOptionTypeModel]()
        
        optionArray.append(ChatOptionTypeModel(optionImage: "Add-people", optionName: "add people" , cellType: .addPeople))
        if isFavourite ?? false {
            optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as unfvt" , cellType: .markFavorite))
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as fvt" , cellType: .markFavorite))
        }
        if isUserMute == "true" {
            optionArray.append(ChatOptionTypeModel(optionImage: "mute-volume-interface-symbol", optionName: "Unmute" , cellType: .mute))
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "mute-volume-interface-symbol", optionName: "Mute" , cellType: .mute))
        }
        optionArray.append(ChatOptionTypeModel(optionImage: "unreadChatMsgs", optionName: "Mark as Unread" , cellType: .markUnread))

        if isArchive ?? false {
            optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "unarchive" , cellType: .archive))
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "archive" , cellType: .archive))
        }
        optionArray.append(ChatOptionTypeModel(optionImage: "Report", optionName: "report" /*"Report"*/, cellType: .report))
        
        completion(optionArray)
    }
    
    // for group chat Notification options
    func addNotificationOptions(isGroupMute:String?, completion:@escaping ([ChatOptionTypeModel]) -> Void){
        
        var optionArray = [ChatOptionTypeModel]()
        optionArray.append(ChatOptionTypeModel(optionImage: "Add-people", optionName: "all activity", cellType: .allActivity))
        optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "only mentions", cellType: .onlyMentions))
        optionArray.append(ChatOptionTypeModel(optionImage: "mute-volume-interface-symbol", optionName: "mute notifications", cellType: .muteNotifications))

        completion(optionArray)
    }
}

struct encryptedKeys {
    static let deliveryStatus1 = "FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFeOnE"
    static let deliveryStatus2 = "FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFeTwO"
    static let deliveryStatus3 = "FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFeThReE"
    static let deliveryStatus4 = "FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFeFoUr"
}

//class ChatOptionTypeModel: NSObject {
//
//    var optionImage, optionName: String?
//    var cellType: chatOptionsType
//
//    init(optionImage: String = "", optionName: String = "", cellType: chatOptionsType){
//        self.optionImage = optionImage
//        self.optionName = optionName
//        self.cellType = cellType
//    }
//}

//enum chatOptionsType: String {
//    case addPeople
//    case markFavorite
//    case mute
//    case markUnread
//    case archive
//    case report
//    case removePeople
//    case renameConversation
//    case notificationSetting
//    case leave
//    case allActivity
//    case onlyMentions
//    case muteNotifications
//}

enum newChatCellType: String {
    case sender
    case receiver
    case notifyMsg
    case offlineMessage
}



