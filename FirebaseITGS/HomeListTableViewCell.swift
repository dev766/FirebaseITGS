//
//  HomeListTableViewCell.swift
//  FirebaseITGS
//
//  Created by Apple on 29/06/22.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var lastMsgLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var onlineStatusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
