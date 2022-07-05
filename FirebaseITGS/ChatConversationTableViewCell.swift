//
//  ChatConversationTableViewCell.swift
//  FirebaseITGS
//
//  Created by Apple on 04/07/22.
//

import UIKit

class ChatConversationTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var noOfMsgTralilingConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupImgBackView: UIView!
    @IBOutlet weak var memberImageView: CircularImage!
    @IBOutlet weak var onlineOfflineLabel: CircularLabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTypeImageView: ITGSVGViewer!
    @IBOutlet weak var favouriteMessageImageView: ITGSVGViewer!
    @IBOutlet weak var muteImgView: UIImageView!
    @IBOutlet weak var muteImgWidth: NSLayoutConstraint!
    @IBOutlet weak var muteImgViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var timeDateLabel: UILabel!
    @IBOutlet weak var noOfMessageLabel: CircularLabel!
    @IBOutlet weak var noOfMsgsWidth: NSLayoutConstraint!
    @IBOutlet weak var messageTypeImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTypeTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var NameImgLabel: CircularLabel!
    
    var messages = [Message]()
    var isSearch:Bool = false
    var searchText:String = ""
    var firebaseService = FirebaseService()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI(messageData: ChatConversation){

        ////To show unread msgs
        
        if let unreadCount = messageData.seen, unreadCount != "" && unreadCount != "0"{
            if Int(unreadCount) != nil{
                let unreadCountInt:Int = Int(unreadCount)!
                if unreadCountInt > 9{
                    self.noOfMessageLabel.text = "9+"
                }else{
                    self.noOfMessageLabel.text = unreadCount
                }
                self.noOfMessageLabel.isHidden = false
                noOfMsgsWidth.constant = 22
                muteImgViewTrailing.constant = 10
                self.noOfMessageLabel.backgroundColor = UIColor.init(hexString: "ED4242")
                memberNameLabel.textColor = UIColor.init(hexString: "000000")
                memberNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
                messageLabel.textColor = UIColor.init(hexString: "000000")

            }else{
                self.noOfMessageLabel.isHidden = true
                noOfMsgsWidth.constant = 0
                muteImgViewTrailing.constant = 0
                memberNameLabel.textColor = UIColor.init(hexString: "313E5A")
                memberNameLabel.font = UIFont(name: "Roboto-Medium", size: 17)
                messageLabel.textColor = UIColor.init(hexString: "313E5A")
            }

        }else{
            self.noOfMessageLabel.isHidden = true
            noOfMsgsWidth.constant = 0
            muteImgViewTrailing.constant = 0
            memberNameLabel.textColor = UIColor.init(hexString: "313E5A")
            memberNameLabel.font = UIFont(name: "Roboto-Medium", size: 17)
            messageLabel.textColor = UIColor.init(hexString: "313E5A")
        }
        
        var chatTitleName = ""
        if messageData.isgroup == true {
            chatTitleName = messageData.name!.getChatuserName()
        }else{
            chatTitleName = messageData.name!
        }
        
        if isSearch{
            messageLabel.attributedText = messageData.lastmsg!.attributedTextForColor(colorString: searchText, attributedColor:UIColor.init(hexString: "0097D6"))
        }
        let attributedString = NSMutableAttributedString(string:chatTitleName)
        memberNameLabel.attributedText = attributedString
        
        
        guard let time = messageData.timestamp else {return}
        let timeStampStr:String = time.stringValue
        
        if let endTime = timeStampStr.dateFromMilliseconds(format: timeStampStr ?? ""){
            
            let dateTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "yyyy-MM-dd HH:mm a")
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? //TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let dateObj1 = dateFormatter.date(from: dateTime)

            let days = Date().daysBetweenDates(startDate: dateObj1!, endDate: Date())
            
            switch(days){
            case 0:
                let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
                timeDateLabel.text = messageTime.lowercased()
                break
            case 1:
                timeDateLabel.text = "yesterday"
                break
            default:
                 let userDateFormatArray = UserDefaults.standard.value(forKey: "DateFormat") as? [String]
                let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: userDateFormatArray?.first ?? "dd/MM/yyyy")
                timeDateLabel.text = messageTime
                break
                
            }
        }
        
        if let isFavourite = messageData.isfavorite,isFavourite {
            favouriteMessageImageView.isHidden = false
        }else{
            favouriteMessageImageView.isHidden = true
        }
        
        if let isMute = messageData.ismute,isMute == "true" || isMute == "3" {
            muteImgView.isHidden = false
            muteImgWidth.constant = 17
            if let unreadCount = messageData.seen, unreadCount != ""{
                muteImgViewTrailing.constant = 10
            }else{
                muteImgViewTrailing.constant = 0
            }
        }else{
            muteImgView.isHidden = true
            muteImgWidth.constant = 0
            muteImgViewTrailing.constant = 0
        }
        
        if let msgType = messageData.message_type /*Int(messageData.message_type ?? "0")*/ {
            
            messageTypeImageWidthConstraint.constant = 15
            messageTypeTrailingConstraint.constant = 10
            messageTypeImageView.isHidden = false
            switch msgType {
            case "0", "text":
                if let lastMessage = messageData.lastmsg?.trimmingCharacters(in: .whitespaces) {
                    if !lastMessage.isEmpty{
                       messageLabel.text = lastMessage
                    }else{
                        messageLabel.text = ""
                    }
                }
                messageTypeImageView.isHidden = true
                self.messageTypeImageWidthConstraint.constant = 0
                self.messageTypeTrailingConstraint.constant = 0
                break
            case "image":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("camera", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chat Photo message"
                messageTypeImageView.isHidden = false
                break
            case "gif":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("Gif", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chatGifMessage"
                messageTypeImageView.isHidden = false
                break
            case "attachment":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("Attachment", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chatAttachmentMessage"
                messageTypeImageView.isHidden = false
                break
            case "audio":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("Voicenote_1", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chat voice Note"
                messageTypeImageView.isHidden = false
                break
            case "video":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("Video", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chat video message"
                messageTypeImageView.isHidden = false
                break
            case "location":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("Location", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chat location message"
                messageTypeImageView.isHidden = false
                break
            case "link":
                DispatchQueue.main.async {
                    self.messageTypeImageView.setSVGWithId("web-link", withColor: UIColor.init(hexString: "2D3F58"))
                }
                messageLabel.text = "chat weblink message"
                messageTypeImageView.isHidden = false
                break
            case "group_message":
                var finalMsgStr = ""
                let spitMsgArr = messageData.lastmsg?.components(separatedBy: "~")
                if spitMsgArr?.count ?? 0 > 0{
                    for str in spitMsgArr ?? []{
                        var msgAfterLocalize = ""
                        if str.hasPrefix("`"){
                            let getKeyOfStr = str.components(separatedBy: "`")[1]
                            msgAfterLocalize = "\(getKeyOfStr)"
                        }else{
                            msgAfterLocalize = str
                        }
                        finalMsgStr.append("\(msgAfterLocalize) ")
                    }
                    messageLabel.text = finalMsgStr
                }
                messageTypeImageView.isHidden = true
                self.messageTypeImageWidthConstraint.constant = 0
                self.messageTypeTrailingConstraint.constant = 0
                break
            default:
                messageLabel.text = ""
                messageTypeImageView.isHidden = true
                print("chat list cell Default")
            }
        }
        
        if messageData.isgroup != true{
            self.onlineOfflineLabel.isHidden = false
            memberImageView.isHidden = false
            groupImgBackView.isHidden = true
            
            let profileURL = URL(string: messageData.profile_pic ?? "")
            let defaultImg = profileURL?.lastPathComponent

            if messageData.profile_pic != "" && defaultImg != "defaultPictureV4.png"{
                self.memberImageView.setImage(link: messageData.profile_pic ?? "", imageType: .UserImage)
            }else{
                let name =  messageData.name ?? ""
                self.memberImageView.setImageForName(name, backgroundColor:nil, circular: true, textAttributes: nil)
            }
            
            if messageData.online != "" && messageData.online != "false"{
                self.onlineOfflineLabel.backgroundColor = UIColor.init(hexString: "73D145")
            }else{
                self.onlineOfflineLabel.backgroundColor = UIColor.init(hexString: "979797")
            }
        }else{
            self.onlineOfflineLabel.isHidden = true
            memberImageView.isHidden = true
            groupImgBackView.isHidden = false
            groupImgBackView.layer.cornerRadius = groupImgBackView.bounds.height/2
        }
        self.onlineOfflineLabel.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        self.onlineOfflineLabel.layer.borderWidth = 1

    }
    
    
    func setupUI(messageData: User)
    {
        onlineOfflineLabel.layer.borderWidth = 1
        onlineOfflineLabel.layer.borderColor = UIColor.white.cgColor
        
        if let name = messageData.name {
            memberNameLabel.text = name
        }
        
        if let userImg = messageData.image {
            memberImageView.image = UIImage(named: "Default-User")
        }
        
        if let onlineStatus = messageData.online  {
            if onlineStatus == "1" {
               onlineOfflineLabel.backgroundColor = UIColor.init(hexString: "73D145")
            } else {
                onlineOfflineLabel.backgroundColor = UIColor.init(hexString: "979797")
            }
        }
        
    }
    
}
