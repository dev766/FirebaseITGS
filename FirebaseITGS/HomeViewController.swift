//
//  HomeViewController.swift
//  FirebaseITGS
//
//  Created by Apple on 29/06/22.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingButton()
        firebaseAuth()
        loadChatConversation()
    }
    
    func setupFloatingButton(){
        let floatingButton = UIButton()
        floatingButton.setTitle("+", for: .normal)
        floatingButton.backgroundColor = .systemBlue
        floatingButton.layer.cornerRadius = 25
        floatingButton.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        //floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    @IBAction func moreButtonAction(_ sender: UIBarButtonItem) {
        print("more button press")
    }
    
    @objc func plusButtonClick(sender : UIButton) {
        print("add button press")
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
                    self.tableview.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homelistcell") as! HomeListTableViewCell
//        cell.profileImage.image  = UIImage(systemName: "face.smiling")
        cell.nameLBL.text = conversationList[indexPath.row].name
        cell.lastMsgLBL.text = conversationList[indexPath.row].lastmsg
        return cell
    }



}
