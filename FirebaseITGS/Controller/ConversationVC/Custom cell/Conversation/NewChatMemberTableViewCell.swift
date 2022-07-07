//
//  NewChatMemberTableViewCell.swift
//  PeopleHr
//
//  Created by It Gurus Software on 14/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit

protocol NewChatMemberDelegate {
    func sendRemoveUser(userId: Int)
}


class NewChatMemberTableViewCell: UITableViewCell{

    @IBOutlet weak var memberImageView: UIImageView!    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet var designationLabel: UILabel!
    @IBOutlet weak var checkUncheckImageView: UIImageView!
    @IBOutlet weak var userNameImgLabel: UILabel!

    // for removePeople screen
    @IBOutlet weak var checkUncheckImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkUncheckImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var removePeopleButton: UIButton!
    @IBOutlet weak var borderLineView: UIView!
    @IBOutlet var cellShadowView: shadowView!    
    @IBOutlet var designationLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var designationLabelTopConstraint: NSLayoutConstraint!
    
    var delegate: NewChatMemberDelegate?
    var isColorSet = false
    
    // for choose person VC,to avoid flicker effect on selection process (while reloading rows) in 7 plus
    var isChecked: Bool? {
        didSet{
            DispatchQueue.main.async {
                if self.isChecked ?? false{
                    self.checkUncheckImageView.image = UIImage(named: "CircleSelect")
                }else{
                    self.checkUncheckImageView.image = UIImage(named: "CircleUnselect")
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        generateAccessibilityIdentifiers()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
    }
    
    func setupCellForRemovePeople(chatUser: User){
        
        // for remove people screen
        if let userId = chatUser.emp_id {
            removePeopleButton.tag = Int(userId) ?? 0
        }
        
        if let name = chatUser.name {
            memberNameLabel.text = name
        }
        
        self.memberImageView.layer.cornerRadius = self.memberImageView.bounds.height / 2
        self.memberImageView.clipsToBounds = true
        self.userNameImgLabel.isHidden = true
        DispatchQueue.main.async {
            
            let profileURL = URL(string: chatUser.image as? String ?? "")
            let defaultImg = profileURL?.lastPathComponent

            if chatUser.image as? String != "" && defaultImg != "defaultPictureV4.png"{
                let name =  chatUser.name ?? ""
                self.memberImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)
            }else{
                let name =  chatUser.name ?? ""
                
                self.memberImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)

            }
        }
    }
    func setupCell(chatUser: EmployeeDetailsList){
        
        // for remove people screen
        if let userId = chatUser.employeeID {
            removePeopleButton.tag = Int(userId) ?? 0
        }
        
        let fname = chatUser.firstName?.replacingOccurrences(of: "@", with: "")
        let fullName = fname?.getFullName(lastName: [chatUser.lastName!])
        if let name = fullName{
            memberNameLabel.text = name
        }
        
        self.memberImageView.layer.cornerRadius = self.memberImageView.bounds.height / 2
        self.memberImageView.clipsToBounds = true
        self.userNameImgLabel.isHidden = true
        let profileURL = URL(string: chatUser.picture ?? "")
        let defaultImg = profileURL?.lastPathComponent

        if chatUser.picture != "" && defaultImg != "defaultPictureV4.png"{
            self.memberImageView.setImage(link: chatUser.picture ?? "", imageType: .UserImage)
        }else{
            let name =  fullName ?? ""
            
            self.memberImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)

            self.userNameImgLabel.accessibilityIdentifier = "newChatMemberTableViewCell_userNameImg"
        }
        
    }
    
    
    func setupCellForReport(chatUser: EmployeeDetailsList){
        
        // for remove people screen
        if let userId = chatUser.employeeID {
            removePeopleButton.tag = Int(userId) 
        }
        
        if let name = chatUser.firstName?.getFullName(lastName: [chatUser.lastName!]) {
            memberNameLabel.text = name
        }
        
        self.memberImageView.layer.cornerRadius = self.memberImageView.bounds.height / 2
        self.memberImageView.clipsToBounds = true
        let profileURL = URL(string: chatUser.picture ?? "")
        let defaultImg = profileURL?.lastPathComponent

        if chatUser.picture != "" && defaultImg != "defaultPictureV4.png"{
            self.memberImageView.setImage(link: chatUser.picture ?? "", imageType: .UserImage)
        }else{
            let name =  memberNameLabel.text ?? ""
            
            self.memberImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)

        }
    }
    
    // for Thanks module - choosePerson Viewcontroller
    func setupChoosePersonCell(employee: EmployeeDetailsList){
        
        // for remove people screen
        if let userId = employee.employeeID {
            removePeopleButton.tag = Int(userId)
        }
        
        self.memberImageView.layer.cornerRadius = self.memberImageView.bounds.height / 2
        self.memberImageView.layer.masksToBounds = true
        if let employeeImage = employee.picture {
           self.memberImageView.setImage(link: employeeImage, imageType: .UserImage)
        }
        
        if let firstName = employee.firstName, let lastName = employee.lastName {
            memberNameLabel.text = firstName + " " + lastName
        }
        
        if let designation = employee.jobRole {
            designationLabel.text = designation
        }
    }
    
    // from chat module, remove user from group
    @IBAction func removePeopleButtonAction(_ sender: Any) {
        guard let button: UIButton = sender as? UIButton else { return }
        delegate?.sendRemoveUser(userId: button.tag)
    }
    
    
}
