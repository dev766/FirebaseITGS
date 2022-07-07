//
//  SenderCellTableViewCell.swift
//  FirebaseITGS
//
//  Created by S.S Bhati on 06/07/22.
//

import UIKit
import Firebase
import NaturalLanguage

class SenderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var backShadowView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sentStatusImgView: UIImageView!
    @IBOutlet weak var sentStatusImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var sentStatusLeading: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var senderBackShadowViewTopConstraint: NSLayoutConstraint!
    var viewController: NewChatConversationViewController?
    var dataObj: Message!
    var cellIndex: Int!
    var currentIndexPath: IndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(dataObj: Message, previousdataObj: Message, msgKey:String, indexPath: Int, isSeenbyReceiver: String, isGroupConv:Bool?, currentIndexPath:IndexPath)
    {
        self.dataObj = dataObj
        self.cellIndex = indexPath
        self.currentIndexPath = currentIndexPath
        
        if let message = dataObj.payload {
            
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
            messageLabel.attributedText = finalAttributedStr
        }
                
        
        guard let time = dataObj.timeStamp else {return}
        guard let timeStampStr:String? = time.stringValue else {return}
        
        guard let prevTime = previousdataObj.timeStamp else {return}
        guard let prevTimeStampStr:String? = prevTime.stringValue else {return}
        let prevTimemy = prevTimeStampStr?.dateFromMilliseconds(format: prevTimeStampStr ?? "")
        
        let endTimemy = timeStampStr?.dateFromMilliseconds(format: timeStampStr ?? "")
        let interval = endTimemy!.timeIntervalSince(prevTimemy!)
        let duration = Int(interval)
        let durationMinutes = (duration / 60) % 60
        
        /////add 20px spacing for oppsite type(receiver) cell
        if dataObj.from_id != previousdataObj.from_id{
            self.senderBackShadowViewTopConstraint.constant = 20
        }else{
            self.senderBackShadowViewTopConstraint.constant = 5
        }
        
            timeLabel.isHidden = false
            timeLabelHeight.constant = 15
            sentStatusImgViewWidth.constant = 0
            sentStatusLeading.constant = 0
            
            if let endTime = timeStampStr?.dateFromMilliseconds(format: timeStampStr ?? ""){
                
                let days = Date().daysBetweenDates(startDate: endTime, endDate: Date())
                
                switch(days){
                case 0:
                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
                    timeLabel.text = messageTime.lowercased()
                    timeLabel.isHidden = false
                    timeLabelHeight.constant = 15
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
        if isGroupConv ?? false{
            if dataObj.deliverd_status ?? "" == "1" || !(dataObj.isFileUploadedOnAWS ?? false){
                self.sentStatusImgView.image = UIImage(named: "pendingMsg")
                sentStatusImgViewWidth.constant = 15
                sentStatusLeading.constant = 10
                timeLabelHeight.constant = 15
            }else{
                sentStatusImgViewWidth.constant = 0
                sentStatusLeading.constant = 0
                    timeLabel.isHidden = false
                    timeLabelHeight.constant = 15
            }
        }else{
            sentStatusImgViewWidth.constant = 15
            sentStatusLeading.constant = 10
            timeLabelHeight.constant = 15
            if dataObj.deliverd_status ?? "" == "1" || !(dataObj.isFileUploadedOnAWS ?? false){
                self.sentStatusImgView.image = UIImage(named: "pendingMsg")
            }else if dataObj.deliverd_status ?? "" == "2"{
                self.sentStatusImgView.image = UIImage(named: "sentMsg")
            }else if dataObj.deliverd_status ?? "" == "3"{
                self.sentStatusImgView.image = UIImage(named: "readMsg")
            }else if dataObj.deliverd_status ?? "" == "4"{
                self.sentStatusImgView.image = UIImage(named: "deliveredMsg")
            }
        }
    }
    
    override func layoutSubviews() {
       
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
