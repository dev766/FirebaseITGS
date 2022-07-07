//
//  ChatOptionsTableViewCell.swift
//  PeopleHr
//
//  Created by It Gurus Software on 13/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit

class ChatOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImageView: ITGSVGViewer!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var optionRightSideImgView: UIImageView!
    @IBOutlet weak var optionImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionImageTrailingConstraint: NSLayoutConstraint!
    
    var dataObj: [String:String]?
    var showIcons: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        optionImageView.accessibilityIdentifier = Constant.AccessibilityIdentifiers.ChatOptions_optionImage
//        optionNameLabel.accessibilityIdentifier = Constant.AccessibilityIdentifiers.ChatOptions_optionName
//        optionRightSideImgView.accessibilityIdentifier = Constant.AccessibilityIdentifiers.ChatOptions_optionRightSideImg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
//        DispatchQueue.main.async { [weak self] in
//            if let dataObj = self?.dataObj {
//                self?.setupUI(dataObj: dataObj)
//            }
//        }
    }
    
    func setupUI(dataObj: ChatOptionTypeModel)
    {
        self.optionImageView.isHidden = true
        DispatchQueue.main.async { [weak self] in
            if self?.showIcons == true {
                self?.optionImageWidthConstraint.constant = 22
                self?.optionImageTrailingConstraint.constant = 20
                self?.optionImageView.isHidden = false
                if let optionImage =  dataObj.optionImage {
                    self?.optionImageView.setSVGWithId(optionImage as NSString, withColor: UIColor.init(hexString: "2D3F58"))
                }
            } else {
                self?.optionImageView.isHidden = true
                self?.optionImageWidthConstraint.constant = 0
                self?.optionImageTrailingConstraint.constant = 0
            }
            
            self?.optionNameLabel.text = dataObj.optionName
            self?.optionNameLabel.accessibilityIdentifier = "chatOptions_\(dataObj.optionName ?? "")"
        }
        
    }
}
