//
//  ViewController.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    var chatUserRefrance: DatabaseReference!
    var firebaseService = FirebaseService()
    var globalsnapshot = NSDictionary()
    var chatConversationListViewModel = ChatConversationListViewModel()
    
    var friendList = [String: Any]()
    var conversationList = [ChatConversation]()
    var unArchiveConversationList = [ChatConversation]()
    var archiveConversationList = [ChatConversation]()
    var favouriteConversationList = [ChatConversation]()
    var activeConversationList = [ChatConversation]()
    var allConversationList = [ChatConversation]()
    var favouriteUnArchivedConversationList = [ChatConversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseAuth()
        loadChatConversation()
    }
    
    func firebaseAuth() {
        ChatAuthservice.shareInstance.emailLogin("sam2@gmail.com", password: "Password@1", fullName: "Sam2 Bhati", empId: 101, deviceToken: "aavvssyyddff", completion: { isSuccess, message in
            if isSuccess {
                print("login SuccessFully")
            }else {
                print("login failed: \(message)")
            }
        })
    }
    
    func loadChatConversation(){
        let currentUserId = "WLRZzIyxLAU6Z2qrLGhpcHvVWT23"
        chatUserRefrance = firebaseService.databaseChats1().child(currentUserId)
        chatUserRefrance.keepSynced(true)
        chatUserRefrance.observeSingleEvent(of: .value) { (snapshot) in
            
            if let globalsnapshot = snapshot.value as? NSDictionary {
                self.globalsnapshot = globalsnapshot
                
                self.chatConversationListViewModel.loadAllFireBaseMessage11(snapshot: snapshot.value as! NSDictionary) { (conversationList,archiveList,favouriteList,activeList,allList,favouriteUnArchivedConversationList,unreadCount) in
                    
                    print("chatUserRefrance in loadConversation is exists")
                    self.unArchiveConversationList = conversationList
                    self.conversationList = conversationList
                    self.archiveConversationList = archiveList
                    self.favouriteConversationList = favouriteList
                    self.activeConversationList = activeList
                    self.allConversationList = allList
                    self.favouriteUnArchivedConversationList = favouriteUnArchivedConversationList
                }
                
            }
            
            if !snapshot.exists() {
                print("chatUserRefrance in loadConversation is not exists")
                return
            }
        }
        self.loadUsers()
    }
    
    func loadUsers() {
        chatUserRefrance = firebaseService.databaseUsers()
        chatUserRefrance.keepSynced(true)
        chatUserRefrance.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.value {
            self.friendList = userSnapshot as! [String: Any]
            }
        }
    }
    
}

