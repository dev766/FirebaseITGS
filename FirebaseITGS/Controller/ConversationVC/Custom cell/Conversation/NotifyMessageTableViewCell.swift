//
//  NotifyMessageTableViewCell.swift
//  FirebaseITGS
//
//  Created by Apple on 06/07/22.
//

import UIKit

class NotifyMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: shadowView!
    @IBOutlet weak var notifyMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(dataObj: Message, previousdataObj: Message, msgKey:String, indexPath: Int)
    {
        if let message = dataObj.payload {
//            notifyMessageLabel.text = message
            
            var finalMsgStr = ""
            let spitMsgArr = message.components(separatedBy: "~")
            if spitMsgArr.count > 0{
                for str in spitMsgArr{
                    var msgAfterLocalize = ""
                    if str.hasPrefix("`"){
                        let getKeyOfStr = str.components(separatedBy: "`")[1]
                        msgAfterLocalize = "\(getKeyOfStr)"
                    }else{
                        msgAfterLocalize = str
                    }
                    finalMsgStr.append("\(msgAfterLocalize) ")
                }
                notifyMessageLabel.text = finalMsgStr
            }
        }
    }
    
}
