//
//  ConversationListViewModel.swift
//  FirebaseITGS
//
//  Created by S.S Bhati on 29/06/22.
//

import Foundation
import Firebase

class ChatConversationListViewModel {
    
    static let instance = ChatConversationListViewModel()

    var conversationList = [ChatConversation]()
    var archiveConversationList = [ChatConversation]()
    var favouriteConversationList = [ChatConversation]()
    var activeConversationList = [ChatConversation]()
    var allConversationList = [ChatConversation]()
    var favouriteUnArchivedConversationList = [ChatConversation]()
    
    var archiveConvSender:DatabaseReference!
    var createdGroupId:String?

    var errorMessage: String!

        
    func loadAllFireBaseMessage11(snapshot: NSDictionary,completion:@escaping ([ChatConversation],[ChatConversation],[ChatConversation],[ChatConversation],[ChatConversation],[ChatConversation],Int) -> Void){
        
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        self.conversationList.removeAll()
        self.archiveConversationList.removeAll()
        self.favouriteConversationList.removeAll()
        self.activeConversationList.removeAll()
        self.allConversationList.removeAll()
        self.favouriteUnArchivedConversationList.removeAll()
        
        var unreadCountStr = 0
        
        if let myContacts = snapshot as? NSDictionary {
            for (_,value) in myContacts {
                if let contactsData = value as? [String:Any] {
                    var conversation:ChatConversation!
                    
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
                                                chatTitleName = decryptedName //contactsData["name"] as? String ?? ""
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
                                        chatTitleName = decryptedName //contactsData["name"] as? String ?? ""
                                    }
                                }
                            }else{
                                chatTitleName = decryptedName //contactsData["name"] as? String ?? ""
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
                            
                            ///To get Archive and nonarchive conversation
                            if contactsData["isarchived"] as? Bool == true || contactsData["isremoved"] as? Bool == true{
                                self.archiveConversationList.append(conversation)
                            } else {
                                self.conversationList.append(conversation)
                            }
                            ///To get favourite conversation
                            if let isfavourite = contactsData["isfavorite"] as? Bool ,isfavourite {
                                self.favouriteConversationList.append(conversation)
                            }
                            
                            ///To get favourite Unarchived conversation
                            if contactsData["isfavorite"] as? Bool == true && contactsData["isarchived"] as? Bool == false{
                                self.favouriteUnArchivedConversationList.append(conversation)
                                
                            }
                            
                            ///To get active Unarchived  conversation
                            if atWork == "true" && contactsData["isarchived"] as? Bool == false {
                                self.activeConversationList.append(conversation)
                            }
                            
                            ///To get all conversations
                            self.allConversationList.append(conversation)
                        }
                        let unreadCount = decryptedSeen
                        if unreadCount != "" && unreadCount != "0"{
                            if contactsData["emp_id"] != nil{
                                unreadCountStr += 1
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
                            
                             conversation = ChatConversation(seen: decryptedSeen, emp_id: empid, isfavorite: contactsData["isfavorite"] as? Bool ?? false, lastmsg: decryptedMessage ?? "", isarchived: contactsData["isarchived"] as? Bool ?? false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: timestamp, isgroup: false, name: decryptedName, message_type: decryptedMsgType, online: atWork, toChatId: contactsData["toChatId"] as? String ?? "", isread: contactsData["isread"] as? Bool ?? false, ismute: decryptIsMute, profile_pic: decryptedProfilePic, from_id: contactsData["from_id"] as? String, isMsgSeenByReceiver: decryptIsMsgSeenByReceiver, knownAs: decryptedKnownAs, usersDetailsArr: contactsData["usersDetailsArr"] as? [Any] ?? [], isGroupTitle: contactsData["isgroup_title"] as? Bool ?? false, isremoved: contactsData["isremoved"] as? Bool ?? false, message_key: contactsData["message_key"] as? String)
                            
                            ///To get Archive and nonarchive conversation
                            if contactsData["isarchived"] as? Bool == true || contactsData["isremoved"] as? Bool == true{
                                self.archiveConversationList.append(conversation)
                            } else {
                                self.conversationList.append(conversation)
                            }
                            ///To get favourite conversation
                            if let isfavourite = contactsData["isfavorite"] as? Bool ,isfavourite {
                                self.favouriteConversationList.append(conversation)
                            }
                            
                            ///To get favouriteUnarchived conversation
                            if contactsData["isfavorite"] as? Bool == true && contactsData["isarchived"] as? Bool == false{
                                self.favouriteUnArchivedConversationList.append(conversation)
                                
                            }
                            
                            ///To get active conversation
                            if atWork == "true" && contactsData["isarchived"] as? Bool == false{
                                self.activeConversationList.append(conversation)
                            }
                            
                            ///To get all conversations
                            self.allConversationList.append(conversation)
                        }
                        let unreadCount = decryptedSeen
                        if unreadCount != "" && unreadCount != "0"{
                            if contactsData["emp_id"] != nil{
                                unreadCountStr += 1
                            }

                        }
                    }
                }
                // sort Conversation On Basis of
            }
            self.conversationList = self.sortConversationByTimestamp(conversationlist: self.conversationList)
            self.archiveConversationList = self.sortConversationByTimestamp(conversationlist: self.archiveConversationList)
            self.favouriteConversationList = self.sortConversationByTimestamp(conversationlist: self.favouriteConversationList)
            self.activeConversationList = self.sortConversationByTimestamp(conversationlist: self.activeConversationList)
            self.allConversationList = self.sortConversationByTimestamp(conversationlist: self.allConversationList)
            self.favouriteUnArchivedConversationList = self.sortConversationByTimestamp(conversationlist: self.favouriteUnArchivedConversationList)
            completion(self.conversationList,self.archiveConversationList,self.favouriteConversationList,self.activeConversationList,self.allConversationList,self.favouriteUnArchivedConversationList, unreadCountStr)
        }
    }
    
    func sortConversationByTimestamp(conversationlist:[ChatConversation]) -> [ChatConversation]{
        var conversation = conversationlist
        if(conversation.count > 0){
            
            var sortedArray = conversation.sorted(by: { $0.timestamp!.compare($1.timestamp!) == .orderedDescending })
            
            conversation.removeAll()
            conversation = sortedArray
            sortedArray.removeAll()
        }
        return conversation
    }
    
    func addGroupChatOptions(isFavourite:Bool?,isArchive:Bool?, isRead:Bool?, completion:@escaping ([ChatOptionTypeModel]) -> Void){
         var optionArray = [ChatOptionTypeModel]()
         
         optionArray.append(ChatOptionTypeModel(optionImage: "Add-people", optionName:"Add people", cellType: .addPeople))
         optionArray.append(ChatOptionTypeModel(optionImage: "RemovePeopleFromChat", optionName:"Remove People", cellType: .removePeople))
         optionArray.append(ChatOptionTypeModel(optionImage: "renameChatConversation", optionName:"Rename Conversation", cellType: .renameConversation))
         optionArray.append(ChatOptionTypeModel(optionImage: "Alerts", optionName: "Notification Setting", cellType: .notificationSetting))
         if isFavourite ?? false {
             optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-Unfavorite", optionName: "Mark as Unfavorite" , cellType: .markFavorite))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as favorite" , cellType: .markFavorite))
         }
        if isRead ?? false {
            optionArray.append(ChatOptionTypeModel(optionImage: "unreadChatMsgs", optionName:"Mark As UnRead" , cellType: .markUnread))
        }else{
            optionArray.append(ChatOptionTypeModel(optionImage: "markAsRead", optionName: "Mark As Read" , cellType: .markUnread))
        }
         if isArchive ?? false {
             optionArray.append(ChatOptionTypeModel(optionImage: "UnArchive", optionName:"UnArchive", cellType: .archive))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "Archive" , cellType: .archive))
         }
         optionArray.append(ChatOptionTypeModel(optionImage: "leave", optionName: "leave", cellType: .leave))
         optionArray.append(ChatOptionTypeModel(optionImage: "Report", optionName:"Report", cellType: .report))
         
         completion(optionArray)
     }
     
     // for single chat view
     func addChatOptions(isFavourite:Bool?,isArchive:Bool?, isUserMute: String?, isRead:Bool?, completion:@escaping ([ChatOptionTypeModel]) -> Void){
         
         var optionArray = [ChatOptionTypeModel]()
         
         optionArray.append(ChatOptionTypeModel(optionImage: "Add-people", optionName:"Add people" , cellType: .addPeople))
         if isFavourite ?? false {
             optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-Unfavorite", optionName: "Mark as Unfavorite" , cellType: .markFavorite))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "Mark-as-favorite", optionName: "Mark as favorite" , cellType: .markFavorite))
         }
         if isUserMute == "true" {
             optionArray.append(ChatOptionTypeModel(optionImage: "mute-volume-interface-symbol", optionName: "UnMute"  , cellType: .mute))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "mute-volume-interface-symbol", optionName: "Mute" , cellType: .mute))
         }
         if isRead ?? false {
             optionArray.append(ChatOptionTypeModel(optionImage: "unreadChatMsgs", optionName:"Mark As UnRead" , cellType: .markUnread))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "markAsRead", optionName: "Mark As Read" , cellType: .markUnread))
         }
         if isArchive ?? false {
             optionArray.append(ChatOptionTypeModel(optionImage: "UnArchive", optionName:"UnArchive", cellType: .archive))
         }else{
             optionArray.append(ChatOptionTypeModel(optionImage: "Archive", optionName: "Archive" , cellType: .archive))
         }
         optionArray.append(ChatOptionTypeModel(optionImage: "Report", optionName: "Report" /*"Report"*/, cellType: .report))
         
         completion(optionArray)
     }
    
}
