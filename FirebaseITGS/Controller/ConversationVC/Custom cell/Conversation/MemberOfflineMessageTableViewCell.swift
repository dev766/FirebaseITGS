//
//  MemberOfflineMessageTableViewCell.swift
//  PeopleHr
//
//  Created by It Gurus Software on 18/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit

class MemberOfflineMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowBackView: shadowView!
    @IBOutlet weak var offlineMessageLabel: UILabel!
    @IBOutlet weak var cornerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shadowForCornerView(){
        cornerView.layer.masksToBounds = false
        cornerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cornerView.layer.shadowRadius = 3.0
        cornerView.layer.shadowOpacity = 0.1
        
        let path = UIBezierPath()
        
        // Start at the Top Left Corner
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        // Move to the Top Right Corner
        path.addLine(to: CGPoint(x: cornerView.frame.size.width, y: 0.0))
        
        /*// Move to the Bottom Right Corner
         path.addLine(to: CGPoint(x: block1.frame.size.width, y: block1.frame.size.height))
         
         // This is the extra point in the middle :) Its the secret sauce.
         path.addLine(to: CGPoint(x: block1.frame.size.width/2.0, y: block1.frame.size.height/2.0))*/
        
        // Move to the Bottom Left Corner
        path.addLine(to: CGPoint(x: 0.0, y: cornerView.frame.size.height))
        
        path.close()
        
        cornerView.layer.shadowPath = path.cgPath
    }
    
}
