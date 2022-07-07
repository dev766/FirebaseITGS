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
    var filterConversationList = [ChatConversation]()
    var friendList = [String: Any]()
    var users = [User]()
    var conversationList = [ChatConversation]()
    var unArchiveConversationList = [ChatConversation]()
    var archiveConversationList = [ChatConversation]()
    var favouriteConversationList = [ChatConversation]()
    var activeConversationList = [ChatConversation]()
    var allConversationList = [ChatConversation]()
    var favouriteUnArchivedConversationList = [ChatConversation]()
    var seatchTextForSearching:String = ""
    var isSearch:Bool = false
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()


    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNib()
        searchbar.delegate = self
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
    
    fileprivate func loadNib() {
        Bundle.main.loadNibNamed("ChatConversationTableViewCell", owner: self, options: [:])
        tableview.register(UINib(nibName:"ChatConversationTableViewCell", bundle: nil), forCellReuseIdentifier:"chatConversation")

//        tableView.register(UINib(nibName:Constant.CustomCellNibName.firstTableViewCell, bundle: nil), forCellReuseIdentifier:  Constant.ReuseCellIdentifier.FirstCell)
//
//        tableView.register(UINib(nibName:Constant.CustomCellNibName.noChatTableViewCell, bundle: nil), forCellReuseIdentifier:  Constant.ReuseCellIdentifier.noChatViewCell)


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
            print(snapshot)
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
                for indexx in 0...(self.friendList.count - 1) {
                    let index = self.friendList.index(self.friendList.startIndex, offsetBy: indexx)
                    let key = self.friendList.keys[index]
                    
                    if let value = self.friendList[key] as? [String: Any] {
                        
                        if let uuid = value["uuid"] as? String, let name = value["name"] as? String {
                            let user = User(UUID: uuid, deviceToken: "", name: name, online: "", image: "", emp_id: "", isSelected: false, deviceType: "", knownAs: "", empStatus: "")
                            self.users.append(user)
                        } else {
                            let user = User(UUID: value["uuid"] as? String ?? "null", deviceToken: "", name: value["name"] as? String ?? "null", online: "", image: "", emp_id: "", isSelected: false, deviceType: "", knownAs: "", empStatus: "")
                            self.users.append(user)
                        }
                    }
                }
                
            }
        }
    }



    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            return filterConversationList.count
        }else{
           return conversationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"chatConversation", for: indexPath) as? ChatConversationTableViewCell else {return UITableViewCell()}
        cell.setupUI(messageData: conversationList[indexPath.row])
        return cell
//        if isSearch{
//            cell.nameLBL.text = filterConversationList[indexPath.row].name
//            cell.lastMsgLBL.text = filterConversationList[indexPath.row].lastmsg
//            return cell
//        }else{
//            cell.nameLBL.text = conversationList[indexPath.row].name
//            cell.lastMsgLBL.text = conversationList[indexPath.row].lastmsg
//            return cell
//        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewChatConversationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController : UISearchBarDelegate  {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
//        self.removeRefreshControl()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.initRefreshControl()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count >= 3 || searchText.count == 0{
            seatchTextForSearching = searchText
            
            if searchText.count == 0{
                isSearch = false
            }else{
                isSearch = true
            }
            
            self.ifSearchingUpdateDataAsPerChange(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        self.filterButton.isHidden = false
        isSearch = false
        seatchTextForSearching = ""
//        hideFirstRowOnSearchBarClick = false
//        setUpNavigation()
        //newadded
        //        if self.conversationList.count <= 1{
        //            self.tableView.isScrollEnabled = false
        //        }else{
        //            self.tableView.isScrollEnabled = true
        //        }
        if conversationList.count > 1{
            
        }
        if searchbar.text!.isEmpty{
            
//            DispatchQueue.main.async {
//                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//                self.tableView.performBatchUpdates(nil) { (isReloaded) in
//                    if isReloaded{
//                        self.setDefaultContentSizeToTableView()
//                    }
//                }
//            }
        }else{
            self.ifSearchingUpdateDataAsPerChange(searchText: "")
        }
    }
    
    
    func ifSearchingUpdateDataAsPerChange(searchText:String){
        
        self.filterConversationList = []
        
        let filterConversationList1 =  (searchText.isEmpty ? conversationList : conversationList.filter({ (item) -> Bool in
            let value: NSString = item.name! as NSString
            return (value.range(of: searchText, options: .caseInsensitive).location != NSNotFound)
        }))
        
        let filterConversationList2 =  (searchText.isEmpty ? conversationList : conversationList.filter({ (item) -> Bool in
            let value: NSString = item.lastmsg! as NSString
            return (value.range(of: searchText, options: .caseInsensitive).location != NSNotFound)
        }))
        
        
        let filterConversationList3 =  (searchText.isEmpty ? conversationList : conversationList.filter({ (item) in
            let value = item.usersDetailsArr.filter({(groupItem) -> Bool in
                var value2: NSString = ""
                if let groupItemDetails = groupItem as? [String:Any]{
                    value2 = FirebaseService.instance.decryptTextMethod(text: groupItemDetails["name"] as? NSString as String? ?? "" as String) as NSString
                }
                return (value2.range(of: searchText, options: .caseInsensitive).location != NSNotFound)
            })
            if value.count > 0{
                return true
            }
            return false
        }))
        
        let filterConversationList4 =  (searchText.isEmpty ? conversationList : conversationList.filter({ (item) in
            let value = item.usersDetailsArr.filter({(groupItem) -> Bool in
                var value2: NSString = ""
                if let groupItemDetails = groupItem as? [String:Any]{
                    value2 = FirebaseService.instance.decryptTextMethod(text: groupItemDetails["knownAs"] as? NSString as String? ?? "" as String) as NSString
                }
                return (value2.range(of: searchText, options: .caseInsensitive).location != NSNotFound)
            })
            if value.count > 0{
                return true
            }
            return false
        }))
        
        
        for filterChatConv in filterConversationList1{
            if !self.filterConversationList.contains(where: { $0.toChatId == filterChatConv.toChatId }){
                self.filterConversationList.append(filterChatConv)
            }
        }
        for filterChatConv in filterConversationList2{
            if !self.filterConversationList.contains(where: { $0.toChatId == filterChatConv.toChatId }){
                self.filterConversationList.append(filterChatConv)
            }
        }
        
        for filterChatConv in filterConversationList3{
            if !self.filterConversationList.contains(where: { $0.toChatId == filterChatConv.toChatId }){
                self.filterConversationList.append(filterChatConv)
            }
        }
        
        for filterChatConv in filterConversationList4{
            if !self.filterConversationList.contains(where: { $0.toChatId == filterChatConv.toChatId }){
                self.filterConversationList.append(filterChatConv)
            }
        }
        
        if(searchText.count == 0){
            isSearch = true
        }else{
//            self.filterConversationList.insert(chatConEmpty, at: 0)
        }
        
        //        //newadded
        //        if self.filterConversationList.count <= 1{
        //            self.tableView.isScrollEnabled = false
        //        }else{
        //            self.tableView.isScrollEnabled = true
        //        }
//        self.filterConversationList = self.sortConversationByTimestamp(conversationlist: self.filterConversationList)
        DispatchQueue.main.async {
            self.tableview.reloadData()
            //            self.tableView.performBatchUpdates(nil) { (isReloaded) in
            //                if isReloaded{
            //                    self.setDefaultContentSizeToTableView()
            //                }
            //            }
        }
    }
}
