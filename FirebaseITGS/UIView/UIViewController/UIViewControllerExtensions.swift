//
//  UIViewControllerExtensions.swift
//  PeopleHr
//
//  Created by iT Gurus Software on 1/22/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

extension UIViewController {
    
    
    
    func getChatOptionView(optionsArray: [ChatOptionTypeModel],userObj: ChatConversation?,showIcons: Bool, showCheckMark:Bool, optionHeadTitle: String){
        let chatOptionView: ChatOptionsView = UIView.fromNib()
        chatOptionView.delegate = self as? chatOptionDelegate
        chatOptionView.selectedUserObj = userObj
        chatOptionView.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.size.height, width: UIApplication.shared.keyWindow!.frame.width, height: UIApplication.shared.keyWindow!.frame.height)
        chatOptionView.optionArray = optionsArray
        chatOptionView.optionHeadTitleLabel.text = optionHeadTitle
        chatOptionView.showIcons = showIcons
        chatOptionView.showCheckMark = showCheckMark
        UIApplication.shared.keyWindow!.addSubview(chatOptionView)
        UIView.animate(withDuration: 0.1) {
            chatOptionView.frame = CGRect(x: UIApplication.shared.keyWindow!.frame.origin.x, y: 0, width: UIApplication.shared.keyWindow!.frame.width, height: UIApplication.shared.keyWindow!.frame.height)
        }
    }
    
    
}
