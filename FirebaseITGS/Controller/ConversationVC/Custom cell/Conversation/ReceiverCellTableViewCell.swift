//
//  ReceiverCellTableViewCell.swift
//  FirebaseITGS
//
//  Created by S.S Bhati on 06/07/22.
//

import UIKit
import FirebaseAuth
import Firebase
import NaturalLanguage

class ReceiverCellTableViewCell: UITableViewCell {


    @IBOutlet weak var backShadowView: shadowView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiverBackShadowViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiverBackShadowViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cornerView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(dataObj: Message, previousdataObj: Message, msgKey:String, userProfile:String, groupMembers:[EmployeeDetailsList], isGroupConv:Bool?, indexPath: Int)
    {
        shadowForCornerView()
        
        if let message = dataObj.payload {
//            messageLabel.text = message
            
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count))
            let emptyStringAtEnd = "                   n"/////Added empty space at end to show time label and message on same line as per message content
            let emptyStringAtEndAttributedStr = emptyStringAtEnd.attributedTextWithBlackUnderLine(url: String(emptyStringAtEnd), color: UIColor.clear)
           
            var finalAttributedStr = NSMutableAttributedString()
            var attributedString = NSMutableAttributedString()
            let detectedLanguage = self.detectedLanguage(for: message)
            if detectedLanguage == "Arabic" || detectedLanguage == "Hebrew" || detectedLanguage == "Persian" || detectedLanguage == "Urdu"{
                let LTRArebicMsg = "\u{200E}" + message
                attributedString = NSMutableAttributedString(string: LTRArebicMsg)
            }else{
                attributedString = NSMutableAttributedString(string: message)
            }
            
            
            if matches.count > 0{
                for match in matches {
                    guard let range = Range(match.range, in: message) else { continue }
                    let urlSting = message[range]
                    if urlSting.lowercased().hasPrefix("www.") || urlSting.lowercased().hasPrefix("http://") || urlSting.lowercased().hasPrefix("https://"){
                        
                        
                        if attributedString.setAsLink(textToFind: String(urlSting), linkURL: String(urlSting)) {
                             finalAttributedStr = attributedString
                            attributedString = finalAttributedStr
                        }
                        finalAttributedStr.append(emptyStringAtEndAttributedStr)
                        
                    }else{
                        finalAttributedStr = attributedString
                        finalAttributedStr.append(emptyStringAtEndAttributedStr)
                        
                    }
                }
            }else{
               
                finalAttributedStr = attributedString
                finalAttributedStr.append(emptyStringAtEndAttributedStr)
                
            }
            
            finalAttributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Regular", size: 17.0)!, range: NSRange(location:0,length:message.count))
            messageLabel.text = message + "                   "
        }
        
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.clipsToBounds = true
        if isGroupConv ?? false{
            userNameLblHeight.constant = 21
            userNameLblBottomConstraint.constant = 5
            userNameLabel.text = dataObj.from_name
            let userData = groupMembers.filter({$0.employeeFirebaseUUID == dataObj.from_id})
            if userData.count > 0{
                
                let profileURL = URL(string: userData[0].picture ?? "")
                let defaultImg = profileURL?.lastPathComponent

                if userData[0].picture != "" && defaultImg != "defaultPictureV4.png"{
//                    self.userImageView?.downloaded(from: userData[0].picture ?? "")
                    let name =  dataObj.from_name ?? ""
                    self.userImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)
                }else{
                    let name =  dataObj.from_name ?? ""
                    self.userImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)
                }
            }
        }else{
            userNameLblHeight.constant = 0
            userNameLblBottomConstraint.constant = 0
           // userNameLabel.isHidden = true
            
            let profileURL = URL(string: userProfile)
            let defaultImg = profileURL?.lastPathComponent

            if userProfile != "" && defaultImg != "defaultPictureV4.png"{
//                self.userImageView?.downloaded(from: userProfile)
                let name =  dataObj.from_name ?? ""
                self.userImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)
            }else{
                let name =  dataObj.from_name ?? ""
                self.userImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)

            }
        }
        
        guard let time = dataObj.timeStamp else {return}
        let timeStampStr:String = time.stringValue
        guard let prevTime = previousdataObj.timeStamp else {return}
        let prevTimeStampStr:String = prevTime.stringValue
        let prevTimemy = prevTimeStampStr.dateFromMilliseconds(format: prevTimeStampStr ?? "")
        
        let endTimemy = timeStampStr.dateFromMilliseconds(format: timeStampStr ?? "")
        let interval = endTimemy!.timeIntervalSince(prevTimemy!)
        let duration = Int(interval)
        let durationMinutes = (duration / 60) % 60
        
        /////add 20px spacing for oppsite type(receiver) cell
        if dataObj.from_id != previousdataObj.from_id{
            self.receiverBackShadowViewTopConstraint.constant = 20
        }else{
            self.receiverBackShadowViewTopConstraint.constant = 5
        }
            timeLabel.isHidden = false
            timeLblHeight.constant = 14
            self.userImageView.isHidden = false
            
            if let endTime = timeStampStr.dateFromMilliseconds(format: timeStampStr ?? ""){
                
            let days = Date().daysBetweenDates(startDate: endTime, endDate: Date())
            switch(days){
                case 0:
                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
                    timeLabel.text = messageTime.lowercased()
                    break
                case 1:
                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
                    timeLabel.text = messageTime.lowercased()
//                    timeLabel.text = "Yesterday"
                    break
                default:
                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
                    timeLabel.text = messageTime.lowercased()

                    break
                }
            }
//        }
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
    
    
    override func layoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    func detectedLanguage(for string: String) -> String? {
        if #available(iOS 12.0, *) {
            let recognizer = NLLanguageRecognizer()
            recognizer.processString(string)
            guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
            let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
            return detectedLanguage
        } else {
            // Fallback on earlier versions
            return ""
        }
    }
}
