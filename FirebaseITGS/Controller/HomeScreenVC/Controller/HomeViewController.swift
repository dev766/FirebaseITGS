//
//  HomeViewController.swift
//  FirebaseITGS
//
//  Created by Apple on 29/06/22.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    var chatUserRefrance: DatabaseReference!
    var firebaseService = FirebaseService()
    var globalsnapshot = NSDictionary()
    var chatConversationListViewModel = ChatConversationListViewModel()
    var filterConversationList = [ChatConversation]()
    var friendList = [String: Any]()
    var conversationList = [ChatConversation]()
    var unArchiveConversationList = [ChatConversation]()
    var archiveConversationList = [ChatConversation]()
    var favouriteConversationList = [ChatConversation]()
    var activeConversationList = [ChatConversation]()
    var allConversationList = [ChatConversation]()
    var favouriteUnArchivedConversationList = [ChatConversation]()
    var users = [User]()
    var seatchTextForSearching:String = ""
    var selectedfilter:String = ""
    var isSearch:Bool = false
    lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    var allMessages = [Message]()
    var allMessagesKeyArr = [String]()
    var toUserObject:ChatConversation!
    var chatConversationViewModel = ChatConversationListViewModel()
    var isGroup = false



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
        let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default, handler: { (action) -> Void in
//            self.changeImageOfFilterIcon(isApplied: false)
            self.selectedfilter = "All"
            self.conversationList = self.unArchiveConversationList//self.allConversationList
//            self.fetchSliderData()
            self.tableview.reloadData()
        })
        allAction.accessibilityLabel = "chatConversation_alertAction_allAction"
        let favAction = UIAlertAction(title:"Favorites", style: .default, handler: {(action) -> Void in
//            self.changeImageOfFilterIcon(isApplied: true)
            self.selectedfilter = "Favorites"
            self.conversationList = self.favouriteConversationList
//            self.fetchSliderData()
            self.tableview.reloadData()
        })
        
        let activeAction = UIAlertAction(title:"Active", style: .default, handler: {(action) -> Void in
//            self.changeImageOfFilterIcon(isApplied: true)
            self.selectedfilter = "Active"
            self.conversationList = self.activeConversationList
//            self.fetchSliderData()
            self.tableview.reloadData()

        })
        
        
        let archivedAction = UIAlertAction(title:"Archived", style: .default, handler: {(action) -> Void in
//            self.changeImageOfFilterIcon(isApplied: true)
            self.selectedfilter = "Archived"
            self.conversationList = self.archiveConversationList
//            self.fetchSliderData()
            self.tableview.reloadData()

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
//            self.changeImageOfFilterIcon(isApplied: false)
            self.selectedfilter = ""
            self.conversationList = self.unArchiveConversationList
//            self.fetchSliderData()
            self.tableview.reloadData()

        })
        
        switch selectedfilter {
        case "All":
//            allAction.setValue(true, forKey: "checked")
            break
        case "Favorites":
            favAction.setValue(true, forKey: "checked")
        case "Active":
            activeAction.setValue(true, forKey: "checked")
        case "Archived":
            archivedAction.setValue(true, forKey: "checked")
        default:
            break
        }
        
        actionSheet.addAction(allAction)
        actionSheet.addAction(favAction)
        actionSheet.addAction(activeAction)
        actionSheet.addAction(archivedAction)
        actionSheet.addAction(cancelAction)

        let height:NSLayoutConstraint = NSLayoutConstraint(item: actionSheet.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300.0)
        
        actionSheet.view.addConstraint(height)
        actionSheet.view.tintColor = UIColor.init(hexString: "0182F8")
        
        self.present(actionSheet, animated: true){
            actionSheet.view.superview?.subviews[0].isUserInteractionEnabled = false
        }
        
    }
    
    @objc func plusButtonClick(sender : UIButton) {
        print("add button press")
    }
    
    func firebaseAuth() {
        ChatAuthservice.shareInstance.emailLogin("sam2@gmail.com", password: "Password@1", fullName: "Sam2 Bhati", empId: 101, deviceToken: "aavvssyyddff", completion: { isSuccess, message in
            if isSuccess {
                print("login SuccessFully")
                UserDefaults.standard.set("WLRZzIyxLAU6Z2qrLGhpcHvVWT23", forKey: "currentUserFireId")
            }else {
                UserDefaults.standard.set("WLRZzIyxLAU6Z2qrLGhpcHvVWT23", forKey: Constant.UserDefaultKeys.cuurentFirId)
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
                    
                    if self.selectedfilter != ""{
                        if self.selectedfilter == "All"{
                            self.conversationList = self.unArchiveConversationList //self.allConversationList
                        }else if self.selectedfilter == "Favorites"{
                            self.conversationList = self.favouriteConversationList
                        }else if self.selectedfilter == "Active"{
                            self.conversationList = self.activeConversationList
                        }else if self.selectedfilter == "Archived"{
                            self.conversationList = self.archiveConversationList
                        }
                    }else{
                        self.conversationList = self.unArchiveConversationList
                    }
                    
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
        firebaseService.fetchUserFromFireBase { users in
            self.users = users
        }
    }

    func showChatOptions(userObj: ChatConversation?,toUserObj: ChatConversation?){
        if let isGroup = userObj?.isgroup {
            var GroupChatOptions = [ChatOptionTypeModel]()
            var SingleChatOptions = [ChatOptionTypeModel]()
            if isGroup{
                self.allMessages = []
                self.allMessagesKeyArr = []
//                self.newChatConversationViewModel.loadAllMessagesGroups(){ (mesages,msgKey) in
//                    self.allMessages = mesages
//                    self.allMessagesKeyArr = msgKey
//                }
            }

            chatConversationViewModel.addGroupChatOptions(isFavourite: userObj?.isfavorite, isArchive: userObj?.isarchived, isRead:userObj?.isread){ (GOptionsArray) in
                GroupChatOptions = GOptionsArray
            }
            chatConversationViewModel.addChatOptions(isFavourite: userObj?.isfavorite, isArchive: userObj?.isarchived, isUserMute: userObj?.ismute, isRead:userObj?.isread){
                (SOptionsArray) in
                SingleChatOptions = SOptionsArray
            }
            self.getChatOptionView(optionsArray: isGroup == true ?  GroupChatOptions : SingleChatOptions ,userObj: userObj,showIcons: true, showCheckMark:false, optionHeadTitle:"text_options")
        }
    }
        

}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            return filterConversationList.count
        }else{
           return conversationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"chatConversation", for: indexPath) as? ChatConversationTableViewCell else {return UITableViewCell()}
        if isSearch{
            cell.setupUI(messageData: filterConversationList[indexPath.row])
            return cell
        }else{
            cell.setupUI(messageData: conversationList[indexPath.row])
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = (self.storyboard?.instantiateViewController(identifier: "NewChatConversationViewController")) as! NewChatConversationViewController
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        if isSearch && filterConversationList.count == 1{
            
        }else if isSearch && filterConversationList.count > 1{
            
            guard let firToUserId = filterConversationList[indexPath.row].toChatId else{ return }
            guard let firToUserName = filterConversationList[indexPath.row].name else{ return }
            guard let firToEmployeeId = filterConversationList[indexPath.row].emp_id else{ return }
            
            if let isGroupClick = filterConversationList[indexPath.row].isgroup,isGroupClick {
                isGroup = false//sss
            }else{
                isGroup = false
            }
            
            UserDefaults.standard.setValue(firToUserId, forKey: "FirToUserId")
            UserDefaults.standard.setValue(firToUserName, forKey: "FirToUserName")
            UserDefaults.standard.setValue(firToEmployeeId, forKey: "ToEmployeeId")
            
            FirebaseService.instance.getToChatUserConversation(toUserId:firToUserId , currentUserId:currentUserId as? String ?? ""){
                chatConv in
                if chatConv.emp_id != ""{
                    self.toUserObject = chatConv
                }
            }
            
            
            if isGroup {
//                goToNewChatIfCurrentUserExistInGroup(index: indexPath.row)
            }else{
                    self.title = ""
                    controller.userObj = filterConversationList[indexPath.row]
                    controller.isGroupConversation = isGroup
                    controller.isFromNewGroupChat = isGroup
                    controller.clickedIndex = indexPath.row
                    controller.toUserObj = self.toUserObject
                    controller.comingFrom = "chatListVC"
                    controller.ProfileImageForSingleUser = filterConversationList[indexPath.row].profile_pic ?? ""
                    self.navigationController?.pushViewController(controller, animated: false)
            }
            
            
        }else if conversationList.count > 1{
            
            guard let firToUserId = conversationList[indexPath.row].toChatId else{ return }
            guard let firToUserName = conversationList[indexPath.row].name else{ return }
            guard let firToEmployeeId = conversationList[indexPath.row].emp_id else{ return }
            
            if let isGroupClick = conversationList[indexPath.row].isgroup,isGroupClick {
                isGroup = true
            }else{
                isGroup = false
            }
            UserDefaults.standard.setValue(firToUserId, forKey: "FirToUserId")
            UserDefaults.standard.setValue(firToUserName, forKey: "FirToUserName")
            UserDefaults.standard.setValue(firToEmployeeId, forKey: "ToEmployeeId")
            
            
            FirebaseService.instance.getToChatUserConversation(toUserId:firToUserId , currentUserId:currentUserId as? String ?? ""){
                chatConv in
                if chatConv.emp_id != ""{
                    self.toUserObject = chatConv
                }
            }
            
            if isGroup {
//                goToNewChatIfCurrentUserExistInGroup(index: indexPath.row)
            }else{
                    self.title = ""
                    controller.userObj = conversationList[indexPath.row]
                    controller.isGroupConversation = isGroup
                    controller.isFromNewGroupChat = isGroup
                    controller.clickedIndex = indexPath.row
                    controller.toUserObj = self.toUserObject
                    controller.comingFrom = "chatListVC"
                    controller.ProfileImageForSingleUser = conversationList[indexPath.row].profile_pic ?? ""
                    self.navigationController?.pushViewController(controller, animated: false)
            }
            
        }

    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
//        self.searchController.searchBar.resignFirstResponder()
        
        if isSearch && filterConversationList.count == 1{
            
        }else if isSearch && filterConversationList.count > 1{
        
        
        }else if self.conversationList.count > 1{
            
            if !(conversationList[indexPath.row].isremoved ?? false){
                                            
//                            self.newChatConversationViewModel.getGroupMembersOfGroup(){ (GrpMembers) in
//                                self.groupMembers = GrpMembers
//                            }
                        
                            let optionsAction: UIContextualAction!
                            let currentUserObject = self.conversationList[indexPath.row]
                            if currentUserObject.isarchived ?? false{
                                 optionsAction =  UIContextualAction(style: .normal, title: "Unarchieve" , handler: { (optionsAction,view,completionHandler ) in
                                    self.firebaseService.setMarkAsArchive(userObj: self.conversationList[indexPath.row]) { (success) in
                                        if success {
                                            print("Reload Table")
                                            self.loadChatConversation()
                                            self.tableview.reloadData()
                                        }
                                    }
                                    completionHandler(true)
                                })
                                optionsAction.isAccessibilityElement = true
                                optionsAction.accessibilityLabel = "ChatConversation_swipeAction_unarchive"
                                optionsAction.image?.accessibilityIdentifier = "ChatConversation_swipeAction_unarchiveImage"
//                                optionsAction.image?.accessibilityIdentifier = Constant.AccessibilityIdentifiers.chatConversation_swipeAction_chatArchive
                            }else{
                                 optionsAction =  UIContextualAction(style: .normal, title: "archieve" , handler: { (optionsAction,view,completionHandler ) in
                                    self.firebaseService.setMarkAsArchive(userObj: self.conversationList[indexPath.row]) { (success) in
                                        if success {
                                            print("Reload Table")
                                            self.loadChatConversation()
                                            self.tableview.reloadData()
                                        }
                                    }
                                    completionHandler(true)
                                })
                                
                                optionsAction.image = UIImage(named: "chatArchiveImg2")
                                optionsAction.image?.accessibilityIdentifier = "ChatConversation_swipeAction_archiveImage"
//                                optionsAction.image?.accessibilityIdentifier = Constant.AccessibilityIdentifiers.chatConversation_swipeAction_chatArchive
                                optionsAction.accessibilityLabel = "ChatConversation_swipeAction_archive"
                                
                            }
                            optionsAction.backgroundColor = UIColor(hexString: "313E5A")
                            
                            let archiveAction =  UIContextualAction(style: .normal, title: "text_options" , handler: { (archiveAction,view,completionHandler ) in
                                self.showChatOptions(userObj: self.conversationList[indexPath.row],toUserObj: self.toUserObject)
                                completionHandler(true)
                            })
                            archiveAction.isAccessibilityElement = true
                            archiveAction.image = UIImage(named: "chatOptionsSwipeImg")
                            archiveAction.accessibilityLabel = "chatConversation_swipeAction_options"
//                            archiveAction.image?.accessibilityIdentifier = Constant.AccessibilityIdentifiers.chatConversation_swipeAction_chatOptions
                            archiveAction.backgroundColor = UIColor(hexString: "0097D6")
                            
                            let actionConfiguration = UISwipeActionsConfiguration(actions: [optionsAction,archiveAction])
                            actionConfiguration.performsFirstActionWithFullSwipe = false
                            
                            let firToUserId = conversationList[indexPath.row].toChatId
                            let firToUserName = conversationList[indexPath.row].name
                            let firToEmployeeId = conversationList[indexPath.row].emp_id

                            UserDefaults.standard.setValue(firToUserId, forKey: "FirToUserId")
                            UserDefaults.standard.setValue(firToUserName, forKey: "FirToUserName")
                            UserDefaults.standard.setValue(firToEmployeeId, forKey: "ToEmployeeId")

                            //////Get To Chat user's Chat table data
                            //let currentUserId =  UserDefaults.standard.value(forKey: "currentFireUserId") as? String ?? ""
//                            let currentUserId = Preferences.currentFireUserId ?? ""
//                            let toUserId =  UserDefaults.standard.value(forKey: "FirToUserId") as? String ?? ""
                            
//                            if currentUserId != "" && toUserId != ""{
//                                firebaseService.getToChatUserConversation(toUserId:toUserId, currentUserId:currentUserId ){
//                                    chatConv in
////                                    self.toUserObject = chatConv
//                                }
//
//                                ////get group current chat to set name  after adding people on basis of isGroupTitle
//                                if !(toUserId).isEmpty || !(currentUserId).isEmpty{
//                                    print("databaseGroupChat()child(currentUserId as! String)child(toUserId as! String) groupReferance Chat Conversation2")
//                                    let groupReferance = firebaseService.databaseGroupChat().child(currentUserId ).child(toUserId )
//                                    groupReferance.observe(.value) { (snapshot) in
//                                        print("groupReferance Chat Conversation2")
//                                        if snapshot.exists() {
//                                            if  let messageDict = snapshot.value as? [String: Any]{
//                                                let ifGroupTitle:Bool = messageDict["isgroup_title"] as? Bool ?? false
//                                                self.isGroupTitlevalue = ifGroupTitle
//                                                self.existingGroupName = FirebaseService.instance.decryptTextMethod(text: messageDict["group_tittle"] as! String)
//                                                groupReferance.removeAllObservers()
//                                            }
//                                        }
//                                    }
//                            }
//                            }
                            return actionConfiguration
            }
           
    }
        return UISwipeActionsConfiguration()
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
