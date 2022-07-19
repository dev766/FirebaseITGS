//
//  DropDownVC.swift
//  FirebaseITGS
//
//  Created by S.S Bhati on 12/07/22.
//

import UIKit

protocol DropDownUserModel: AnyObject{
    func selectedUser(user: User)
}

class DropDownViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var noUserView: UIView!
    
    var doneButton: UIBarButtonItem!
    let firebaseService = FirebaseService()
    var chatfilteredData: [User] = []
    var searchFilterData: [User] = []
    var isSearch = false
    
    weak var dropDownDelegate: DropDownUserModel?
    
    var selectedUser: User? {
        didSet {
            if selectedUser?.isSelected ?? false {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
        }
    }
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupSearchBar()
        loadNib()
        loadUsers()
    }
    
    //MARK:- Business Logics
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "Add People")
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonPressed))
        navItem.rightBarButtonItem = doneButton
        navItem.leftBarButtonItem = backButton
        doneButton.isEnabled = false
        navBar.setItems([navItem], animated: false)
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.setImage(UIImage(named: "SearchIcon"), for: UISearchBar.Icon.search, state: UIControl.State.normal);
        searchBar.contentMode = .scaleAspectFit
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.delegate = self
    }
    
    func loadNib() {
        listTableView.register(UINib(nibName:"NewChatMemberTableViewCell", bundle: nil), forCellReuseIdentifier:"NewChatMemberCell")
    }
    
    func loadUsers() {
        firebaseService.fetchUserFromFireBase { users in
            let filteredUser = users.sorted{ $0.name?.localizedCaseInsensitiveCompare($1.name ?? "") == ComparisonResult.orderedAscending}
            self.chatfilteredData = filteredUser
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    
    func setUpNewChatMemberCell(indexPath: IndexPath, userData: [User]) ->  UITableViewCell {
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "NewChatMemberCell", for: indexPath) as? NewChatMemberTableViewCell else {return UITableViewCell()}
        
        cell.selectionStyle = .none
        
        DispatchQueue.main.async {
            cell.checkUncheckImageView.image = UIImage(named: "CircleUnselect")
        }
        
        
        if userData[indexPath.row].isSelected ?? false {
            if !cell.isSelected {
                listTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                DispatchQueue.main.async {
                    cell.checkUncheckImageView.image = UIImage(named: "CircleSelect")
                }
            }
        } else {
            if cell.isSelected {
                DispatchQueue.main.async {
                    cell.checkUncheckImageView.image = UIImage(named: "CircleSelect")
                }
                listTableView.deselectRow(at: indexPath, animated: false)
            }
        }
        
        let model = userData[indexPath.row]
        cell.setupCell(chatUser: model)
        return cell
    }
    
    //MARK:- Actions
    @objc func done() {
        if selectedUser != nil && selectedUser?.isSelected ?? false {
            guard let user = selectedUser else {
                return
            }
            dropDownDelegate?.selectedUser(user: user)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- SearchBar Delegate Methods
extension DropDownViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 || searchText.count == 0{
            
            if searchText.count == 0{
                isSearch = false
                searchBar.showsCancelButton = false
            }else{
                isSearch = true
                searchBar.showsCancelButton = true
            }
            
            self.updateDataAsPerChange(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        isSearch = false
        searchBar.showsCancelButton = false
        if searchBar.text!.isEmpty{
            
        }else{
            searchBar.text = ""
            self.updateDataAsPerChange(searchText: "")
        }
    }
    
    
    func updateDataAsPerChange(searchText:String){
        
        self.searchFilterData = []
        
        let filterList = chatfilteredData.filter({ (item) -> Bool in
            let value: NSString = item.name! as NSString
            return (value.range(of: searchText, options: .caseInsensitive).location != NSNotFound)
        })
        
        self.searchFilterData = filterList
        
        if(searchText.count == 0){
            isSearch = false
        }else{
            isSearch = true
        }
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
}

//MARK:- TableView Delegate Methods
extension DropDownViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return searchFilterData.count
        }else {
            return chatfilteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var userslist: [User] = []
        if isSearch {
            userslist = searchFilterData
        }else {
            userslist = chatfilteredData
        }
        let cell = setUpNewChatMemberCell(indexPath: indexPath, userData: userslist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userslist: [User] = []
        if isSearch {
            userslist = searchFilterData
        }else {
            userslist = chatfilteredData
        }
        
        userslist[indexPath.row].isSelected = !(userslist[indexPath.row].isSelected ?? false)
        selectedUser = userslist[indexPath.row]
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var userslist: [User] = []
        if isSearch {
            userslist = searchFilterData
        }else {
            userslist = chatfilteredData
        }
        
        userslist[indexPath.row].isSelected = false
        selectedUser = userslist[indexPath.row]
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
}
