//
//  ChatOptionsView.swift
//  PeopleHr
//
//  Created by It Gurus Software on 13/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit

protocol chatOptionDelegate {
    func selectedItem(selectedOption: ChatOptionTypeModel,userObj: ChatConversation?)
    
    func dissmissedView()
}

class ChatOptionsView: UIView {
    
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: shadowView!
    @IBOutlet weak var optionHeadTitleLabel: UILabel!
    
    var optionArray = [ChatOptionTypeModel]()
    var delegate: chatOptionDelegate?
    var selectedUserObj: ChatConversation? = nil
    var showIcons: Bool = false
    var showCheckMark: Bool = true
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        optionsTableView.accessibilityIdentifier = "ChatOptionsView_optionTable"
        optionHeadTitleLabel.accessibilityIdentifier = "ChatOptionsView_optionHeadTitle"
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.register(UINib(nibName:"ChatOptionsTableViewCell" , bundle: nil), forCellReuseIdentifier: "chatOptionsCell")
        
        DispatchQueue.main.async { [weak self] in
            
        let screenRect = UIScreen.main.bounds;
        let screenHeight = screenRect.size.height;
        // max height should be 1/2 of screen
        let maxHeightAllowed = screenHeight * 0.5;
        var tableHeightCalculated: CGFloat = 0.0
        
            if let optionCount = self?.optionArray.count {
                self?.optionTableViewHeightConstraint.constant = 60 * CGFloat(optionCount)
            }
            
            if let optionTableViewHeight =  self?.optionTableViewHeightConstraint.constant {
            
                if(optionTableViewHeight < maxHeightAllowed)
                {
                    tableHeightCalculated = optionTableViewHeight
                    self?.backViewHeightConstraint.constant = tableHeightCalculated + 70
                }else
                {
                    tableHeightCalculated = screenHeight * 0.2;
                    self?.backViewHeightConstraint.constant = tableHeightCalculated
                }
            }
         
        }
        
        addTapGuesture()
    }

    override func layoutSubviews() {
        
    }
}

extension ChatOptionsView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatOptionsCell", for: indexPath) as? ChatOptionsTableViewCell else {return UITableViewCell()}
        cell.setupUI(dataObj: optionArray[indexPath.row])
        //cell.dataObj = optionArray[indexPath.row]
        cell.accessibilityIdentifier = "ChatOptionsTableViewCell_optionCells"
        cell.showIcons = showIcons
        cell.selectionStyle = .none
        
        if showCheckMark{
            if selectedUserObj?.ismute == "1"{
                if indexPath.row == 0{
                    cell.optionRightSideImgView.isHidden = false
                }
            }
            if selectedUserObj?.ismute == "2"{
                if indexPath.row == 1{
                    cell.optionRightSideImgView.isHidden = false
                }
            }
            if selectedUserObj?.ismute == "3"{
                if indexPath.row == 2{
                    cell.optionRightSideImgView.isHidden = false
                }
            }
        }
 
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selectedItem(selectedOption: optionArray[indexPath.row],userObj: selectedUserObj)
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    
}

// MARK:- Gesture Delegates
extension ChatOptionsView : UIGestureRecognizerDelegate
{
    func addTapGuesture()
    {
        let tapRec = UITapGestureRecognizer(target: self, action:  #selector(self.dismissView(sender:)))
        tapRec.cancelsTouchesInView = false
        tapRec.delegate = self
        self.addGestureRecognizer(tapRec)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backView))!
        {
            return false
        }
        return true
    }
    
    @objc func dismissView(sender : UITapGestureRecognizer) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        delegate?.dissmissedView()
        self.removeFromSuperview()
    }
}
