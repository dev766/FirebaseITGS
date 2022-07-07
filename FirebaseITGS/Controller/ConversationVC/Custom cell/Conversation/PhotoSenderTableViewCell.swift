//
//  PhotoSenderTableViewCell.swift
//  PeopleHr
//
//  Created by It Gurus Software on 26/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit
import Firebase
import Photos

class PhotoSenderTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: shadowView!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sentStatusImgView: UIImageView!
    @IBOutlet weak var sentStatusImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var sentStatusLeading: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadImgView: ITGSVGViewer!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var senderImgBackView: UIView!
    @IBOutlet weak var senderBackShadowViewTopConstraint: NSLayoutConstraint!
    
    var dataObj: Message!
    var isDownloaded: Bool = false
    var viewController: NewChatConversationViewController?
    var pngImageData: Data?
    var offlineImageDataBeforeDownload: Data?
    var isDownloadingStarted: Bool = false
    var mediaOfflineUrlIfExist:String?
    var msgsArrCount: Int?
    var isGroupConv:Bool?
    var groupMemberList:[Any] = []
    var cellIndex: Int!
    var currentIndexPath: IndexPath!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.senderImageView.image = nil
    }
    
    
    
    func setupEmptyUI(){
        
    }
    
    
    func setupUI(dataObj: Message, previousdataObj: Message, msgKey:String, indexPath: IndexPath, isSeenbyReceiver: String, isGroupConv:Bool?, groupMemberList:[Any], table: UITableView)
    {
//
//        self.showHideLoadinggActivityIndicator(showLoader: false)
//        shadowForCornerView()
//        self.dataObj = dataObj
//        self.isGroupConv = isGroupConv
//        self.groupMemberList = groupMemberList
//        self.cellIndex = indexPath.row
//        self.currentIndexPath = indexPath
//
//            if let message = dataObj.payload {
//                if message != ""{
//                    let imageURL = URL(string: message)
//                    let fileName = imageURL?.lastPathComponent as NSString? ?? ""
//                    let predicate = NSPredicate(format: "messagekey = %@", fileName)
//                    if let offlineURLs = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], offlineURLs.count != 0, let imageData = offlineURLs.first!.imageData{
//                        print("found value in DB")
//
//                        if !(dataObj.isFileUploadedOnAWS ?? false){
//                            self.mediaOfflineUrlIfExist = offlineURLs.first!.mediaOfflineURL
//                            DispatchQueue.main.async {
//                                self.downloadView.isHidden = true
//                                self.downloadImgView.isHidden = false
////                                self.downloadImgView.setSVGWithId("reload", withColor: UIColor.black)
//                            }
//
//                            ///if not uploaded on AWS, exists ijn local db and in progress to upload then showing progress bar
//                            let mediaProgress:String = offlineURLs.first!.mediaProgress ?? ""
//                            if mediaProgress == "processing"{
//                                DispatchQueue.main.async {
//                                    self.showHideLoadinggActivityIndicator(showLoader: true)
//                                    self.downloadImgView.isHidden = true
//                                }
//                            }else{
//                                self.showHideLoadinggActivityIndicator(showLoader: false)
//                                self.downloadView.isHidden = true
//                                self.downloadImgView.isHidden = false
//                                self.downloadImgView.setSVGWithId("reload", withColor: UIColor.black)
//                            }
//                        }else{
//                            DispatchQueue.main.async {
//                                self.showHideLoadinggActivityIndicator(showLoader: false)
//                                self.isDownloaded = true
//                                self.downloadView.isHidden = true
//                                self.downloadImgView.isHidden = true
//                            }
//                        }
//                        self.senderImageView.image = UIImage(data: imageData)
//                        self.senderImageView.contentMode = .scaleAspectFill
//                    }else{
//                        DispatchQueue.global().async {
//                            DispatchQueue.main.async {
//                                if self.isDownloadingStarted{
//                                    self.downloadImgView.isHidden = true
//                                    self.showHideLoadinggActivityIndicator(showLoader: true)
//                                }else{
//                                    self.showHideLoadinggActivityIndicator(showLoader: false)
//                                    self.isDownloaded = false
//                                    self.downloadView.isHidden = false
//                                    self.downloadImgView.isHidden = false
//                                    self.downloadImgView.setSVGWithId("downloadChat", withColor: UIColor.init(hexString: "D2D2D5"))
//                                }
//                            }
//                        }
//
//                        let downloadedMediaPredicate = NSPredicate(format: "mediaKey = %@", fileName)
//                        if let downloadedMedia = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.MediaPreviewDetails, in: CoreDataManager.sharedManager.backgroundContext, with: downloadedMediaPredicate) as? [MediaPreviewDetails], downloadedMedia.count != 0 {
//                            if downloadedMedia.first!.mediaData != nil{
//                                self.senderImageView.image = UIImage(data: downloadedMedia.first!.mediaData!)
//                                self.senderImageView.contentMode = .scaleAspectFill
//                            }
//                        }else{
//                            let mediaUrl = URL(string:message)
//                            DispatchQueue.global().async {
//                                Util.replaceImageUrlWithPreSignedUrl(link: message){
//                                    (preSignedUrl,preSignedStr) in
//
//                                    if let data = try? Data(contentsOf: preSignedUrl)
//                                    {
//                                        let image: UIImage = UIImage(data: data)!
//                                        self.offlineImageDataBeforeDownload = image.jpeg(.lowest)
//                                        DispatchQueue.main.async {
//                                            if let cell = table.cellForRow(at: indexPath) as? PhotoSenderTableViewCell{
//                                                cell.senderImageView.image = UIImage(data: self.offlineImageDataBeforeDownload!)
//                                                cell.senderImageView.contentMode = .scaleAspectFill
//                                            }
//                                        }
//                                        if let managedObj = CoreDataHandler.insertObject(forEntity: Constant.CoreDataEntity.MediaPreviewDetails, in: CoreDataManager.sharedManager.backgroundContext) as? MediaPreviewDetails{
//                                            managedObj.mediaOfflineURL = message
//                                            managedObj.mediaData = self.offlineImageDataBeforeDownload
//                                            managedObj.mediaKey = mediaUrl?.lastPathComponent
//                                            CoreDataManager.sharedManager.saveBackgroundContextAsync()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//
//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
//        longPressGesture.minimumPressDuration = 0.5
//        longPressGesture.delegate = self
//        self.shadowView.addGestureRecognizer(longPressGesture)
//
//        cellButton.layer.setValue(indexPath.row, forKey: "indexPath")
//        cellButton.addTarget(self, action: #selector(cellButtonTapped), for: .touchUpInside)
//
//        guard let time = dataObj.timeStamp as? NSNumber else {return}
//        guard let timeStampStr:String? = time.stringValue else {return}
//
//        guard let prevTime = previousdataObj.timeStamp as? NSNumber else {return}
//        guard let prevTimeStampStr:String? = prevTime.stringValue else {return}
//        let prevTimemy = prevTimeStampStr?.dateFromMilliseconds(format: prevTimeStampStr ?? "")
//
//        let endTimemy = timeStampStr?.dateFromMilliseconds(format: timeStampStr ?? "")
//        //print(Date().timeIntervalSinceReferenceDate)
//        let interval = endTimemy!.timeIntervalSince(prevTimemy!)
//        let duration = Int(interval)
//        let durationMinutes = (duration / 60) % 60
//
//        /////add 20px spacing for oppsite type(receiver) cell
//        if dataObj.from_id != previousdataObj.from_id{
//            self.senderBackShadowViewTopConstraint.constant = 20
//        }else{
//            self.senderBackShadowViewTopConstraint.constant = 5
//        }
//
//        ///if messages from sender within 3 minutes
////        if durationMinutes < 1 && indexPath.row != 0 && dataObj.from_id == previousdataObj.from_id {
////            timeLabel.isHidden = true
////        }else{
//            timeLabel.isHidden = false
//            if let endTime = timeStampStr?.dateFromMilliseconds(format: timeStampStr ?? ""){
//
//                let days = Date().daysBetweenDates(startDate: endTime, endDate: Date())
//
//                switch(days){
//                case 0:
//                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
//                    timeLabel.text = messageTime.lowercased()
//                    break
//                case 1:
//                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
//                    timeLabel.text = messageTime.lowercased()
//                    //                    timeLabel.text = "Yesterday"
//                    break
//                default:
//                    let messageTime = DateHelper().convertDateFormatter(date: endTime, formatterString: "h:mm a")
//                    timeLabel.text = messageTime.lowercased()
//                    break
//                }
//            }
////        }
//
//        if isGroupConv ?? false{
//            if dataObj.deliverd_status ?? "" == "1" || !(dataObj.isFileUploadedOnAWS ?? false){
//                self.sentStatusImgView.image = UIImage(named: "pendingMsg")
//                sentStatusImgViewWidth.constant = 15
//                sentStatusLeading.constant = 10
//                timeLabelHeight.constant = 15
//            }else{
////                self.sentStatusImgView.image = UIImage(named: "")
//                sentStatusImgViewWidth.constant = 0
//                sentStatusLeading.constant = 0
////                if durationMinutes < 1 && indexPath.row != 0 && dataObj.from_id == previousdataObj.from_id {
////                    timeLabel.isHidden = true
////                    timeLabelHeight.constant = 0
////                }else{
//                    timeLabel.isHidden = false
//                    timeLabelHeight.constant = 15
////                }
//            }
//        }else{
//            if dataObj.deliverd_status ?? "" == "1" || !(dataObj.isFileUploadedOnAWS ?? false){
//                self.sentStatusImgView.image = UIImage(named: "pendingMsg")
//            }else if dataObj.deliverd_status ?? "" == "2"{
//                self.sentStatusImgView.image = UIImage(named: "sentMsg")
//            }else if dataObj.deliverd_status ?? "" == "3"{
//                self.sentStatusImgView.image = UIImage(named: "readMsg")
//            }else if dataObj.deliverd_status ?? "" == "4"{
//                self.sentStatusImgView.image = UIImage(named: "deliveredMsg")
//            }
//        }
    }
    
//    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
//        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
//            if viewController != nil{
//                viewController?.onLongPress(existMsg:self.dataObj, editDeleteIndexPath: self.cellIndex, IndexPath: self.currentIndexPath)
//            }
//        }
//    }
    
//    func showHideLoadinggActivityIndicator(showLoader: Bool){
//        if showLoader{
//            self.loadingActivity.startAnimating()
//            self.loadingActivity.isHidden = false
//        }else{
//            self.loadingActivity.stopAnimating()
//            self.loadingActivity.isHidden = true
//        }
//    }
    
//    func getOfflineMediaData(payload: String) -> String{
//        let mediaUrl = URL(string: payload)
//        let fileName = mediaUrl?.lastPathComponent as NSString? ?? ""
//        let predicate = NSPredicate(format: "messagekey = %@", fileName)
//        if let offlineURLs = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], offlineURLs.count != 0{
//            return offlineURLs.first!.mediaOfflineURL ?? ""
//        }else{
//            return ""
//        }
//    }
//
//    @objc func cellButtonTapped(sender: UIButton){
//
//        if dataObj.isFileUploadedOnAWS ?? false{
//            if isDownloaded{
//                let vc = PhotoDetailViewController()
//                vc.mediaOfflineURLToShare = self.getOfflineMediaData(payload: self.dataObj.payload ?? "")
//                vc.image = senderImageView.image
//                vc.senderName = dataObj.from_name
//                if vc.image == nil && vc.imageUrl == nil {
//                    return
//                }
//                let navigationVc = UINavigationController(rootViewController: vc)
//                navigationVc.modalPresentationStyle = .fullScreen
//                viewController?.navigationController?.present(navigationVc, animated: true, completion: nil)
//
//            }else{
//                if NetworkHandler.sharedInstance.checkInternetAndShowAlert() == true{
//                    self.checkForPhotoPermission()
//                }else{
////                    Util.presentAlert(titleMessage: "", message: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, VC: self.viewController!)
//                    showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//                }
//            }
//        }else{
//            if mediaOfflineUrlIfExist != nil{
//
//                DispatchQueue.main.async {
//                    self.showHideLoadinggActivityIndicator(showLoader: true)
//                    self.downloadImgView.isHidden = true
//                }
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//                let filePath="\(documentsPath)/\(mediaOfflineUrlIfExist!)"
//                let awsKeyName = URL(string: dataObj.payload ?? "")?.lastPathComponent
//                Util.updateUploadedImageOnAwsForChat(URL: URL(fileURLWithPath: filePath ),awsName: awsKeyName?.components(separatedBy: ".")[0],selectedMultimediaOption: .image) { (commentUrl,isFileUploadedOnAWS) in
//                    DispatchQueue.main.async {
//                        if isFileUploadedOnAWS{
//                            let imageURL = URL(string: self.dataObj.payload ?? "")
//                            let fileName = imageURL?.lastPathComponent as NSString? ?? ""
//                            let predicate = NSPredicate(format: "messagekey = %@", fileName)
//                            if let recordExists = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], recordExists.count != 0{///if record exists in local db then dont do anything while retrying on aws
//                                self.isDownloaded = true
//                                self.downloadView.isHidden = true
//                                self.downloadImgView.isHidden = true
//                                self.showHideLoadinggActivityIndicator(showLoader: false)
//                            }else{///add to local db if not exist while uploading on aws
//                                if NetworkHandler.sharedInstance.checkInternetAndShowAlert() == true{
//                                    self.checkForPhotoPermission()
//                                }else{
////                                    Util.presentAlert(titleMessage: "", message: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, VC: self.viewController!)
//                                    self.showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//                                }
//                            }
//                            self.setMsgAWSUpdatedStatus(CurrentMsgKey: self.dataObj.messageKey ?? "")
//                        }else{
//                            self.downloadImgView.isHidden = false
//                            self.downloadImgView.setSVGWithId("reload", withColor: UIColor.black)
////                            self.viewController?.alert(afterResponse: "", message: Constant.AlertMessages.uplodaingImageErrorMsg.localizedString, cancelBtnTitle: Constant.AlertButtonNames.okButton.localizedString, homeController: self.viewController)
//                            self.showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.uplodaingImageErrorMsg.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//                        }
//                        self.showHideLoadinggActivityIndicator(showLoader: false)
//                    }
//                }
//            }else{///add to local db if not exist while uploading on aws
//                //                self.SaveMediaToLocalDbAndDevice()
//
////                Util.presentAlert(titleMessage: "", message: Constant.AlertMessages.mediaNotAvailable.localizedString, VC: self.viewController!)
//                showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.mediaNotAvailable.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//
//            }
//        }
//    }
//
//    func SaveMediaToLocalDbAndDevice(){
//
//
//
//        //            DispatchQueue.main.async {
//        if NetworkHandler.sharedInstance.checkInternetAndShowAlert() == true{
//            DispatchQueue.main.async {
//                self.showHideLoadinggActivityIndicator(showLoader: true)
//                self.downloadImgView.isHidden = true
//            }
//
//            DispatchQueue.global(qos: .background).async {
//                self.isDownloadingStarted = true
//
//                var mediaStr: String = ""
//                Util.replaceImageUrlWithPreSignedUrl(link: self.dataObj.payload ?? ""){
//                    (preSignedUrl,preSignedStr) in
//                    mediaStr = preSignedStr
//
//                    guard let url = URL(string: mediaStr) else { return }
//                    URLSession.shared.dataTask(with: url) { data, response, error in
//                        guard
//                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
////                            let mimeType = response?.mimeType, mimeType.hasPrefix("image/jpg"),
//                            let data = data, error == nil,
//                            let image = UIImage(data: data)
//                            else { return }
//                            self.pngImageData = image.jpeg(.lowest)
//                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//
//                            let imageURL = URL(string: self.dataObj.payload ?? "")
//                            let fileName = imageURL?.lastPathComponent as NSString? ?? ""
//                            let predicate = NSPredicate(format: "messagekey = %@", fileName)
//                            if let deleteURL = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], deleteURL.count != 0{
//                                for record in deleteURL{
//                                    CoreDataHandler.deleteRecord(managedObject: record, in: CoreDataManager.sharedManager.backgroundContext)
//                                }
//                            }
//                            let filename = NSUUID().uuidString + ".jpg"
//                            let fileUrlDatabase = "\(filename)"
//                            self.mediaOfflineUrlIfExist = "\(fileUrlDatabase)"
//
//                            if let managedObj = CoreDataHandler.insertObject(forEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext) as? ChatAttachment{
//                                managedObj.mediaOfflineURL = "\(fileUrlDatabase)"
//                                managedObj.imageData = self.pngImageData
//                                if let amazonStringURL = self.dataObj.payload, let amazonURL = URL(string: amazonStringURL){
//                                    managedObj.messagekey = amazonURL.lastPathComponent
//                                }
//                                CoreDataManager.sharedManager.saveBackgroundContextAsync()
//                                DispatchQueue.main.async {
//                                    self.isDownloadingStarted = false
//                                    self.isDownloaded = true
//                                    self.downloadView.isHidden = true
//                                    self.downloadImgView.isHidden = true
//                                    self.senderImageView.image = UIImage(data: self.pngImageData!)
//                                    self.senderImageView.contentMode = .scaleAspectFill
//                                    self.showHideLoadinggActivityIndicator(showLoader: false)
//                                }
//                            }
//
//                        }.resume()
//                }
//            }
//        }else{
////            Util.presentAlert(titleMessage: "", message: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, VC: self.viewController!)
//            showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//        }
//        //            }
//    }
//
//    func checkForPhotoPermission(){
//        UserDefaults.standard.set("true", forKey: "isSystemAlert")
//        let photos = PHPhotoLibrary.authorizationStatus()
//        if photos == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({status in
//                DispatchQueue.main.async {
//                    if status == .authorized{
//                        self.SaveMediaToLocalDbAndDevice()
//                    } else {
//                        self.viewController?.askForPhotoPermissionMethod()
//                    }
//                }
//            })
//        }else{
//            if photos == .authorized {
//                self.SaveMediaToLocalDbAndDevice()
//            }else{
//                self.viewController?.askForPhotoPermissionMethod()
//            }
//        }
//    }
//
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
        
        path.addLine(to: CGPoint(x: cornerView.frame.size.width, y: cornerView.frame.size.height))
        /*// Move to the Bottom Right Corner
         path.addLine(to: CGPoint(x: block1.frame.size.width, y: block1.frame.size.height))
         
         // This is the extra point in the middle :) Its the secret sauce.
         path.addLine(to: CGPoint(x: block1.frame.size.width/2.0, y: block1.frame.size.height/2.0))*/
        
        // Move to the Bottom Left Corner
        //path.addLine(to: CGPoint(x: 0.0, y: cornerView.frame.size.height))
        
        path.close()
        
        cornerView.layer.shadowPath = path.cgPath
    }
    
//    
//    func setMsgAWSUpdatedStatus(CurrentMsgKey:String){
//        //guard let currentUserId =  UserDefaults.standard.value(forKey: "currentFireUserId") else {return}
//        let currentUserId = Preferences.currentFireUserId ?? ""
//        if currentUserId == "" {
//            return
//        }
//        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
//        guard let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") else {return}
//
//        ////group members name , seperated
//        let chatUserNamesArr: NSMutableArray = []
//        var conversationNameStr = ""
//        for grpMember in groupMemberList {
//            let memberDict = grpMember as? [String:Any]
//            for(key,value) in memberDict ?? [:] {
//                if(key == "name"){
//                    chatUserNamesArr.add(value )
//                    conversationNameStr = chatUserNamesArr.componentsJoined(by: ",")
//                    conversationNameStr = conversationNameStr.encryptMessage() ?? ""
//                }
//            }
//        }
//        
//        if CurrentMsgKey != ""{
//            if isGroupConv ?? false{
//                
//                ////update message table after sending media successfully
//                let MessageKeySentReferaneceSender = FirebaseService.instance.databaseMessages().child("Groups").child(toUsreId as! String).child(CurrentMsgKey)
//                let message = ["isFileUploadedOnAWS": true, "deliverd_status": Constant.encryptedKeys.deliveryStatus2, "timeStamp": ServerValue.timestamp()] as [String : Any]
//                MessageKeySentReferaneceSender.updateChildValues(message)
//                
//                ////notification send after msg sent status
//                let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
//                let notificationpayload = ["from": currentUserId, "type": "0", "companyId": companyId ?? ""] as [String : Any]
//                let notificationRef = FirebaseService.instance.databaseNotification().child(toUsreId as! String).child(CurrentMsgKey)
//                notificationRef.setValue(notificationpayload)
//                
//                
//                for member in groupMemberList{
//                    let memberDict = member as? [String:Any]
//                    for(key,value) in memberDict ?? [:] {
//                        if(key == "groupMemberId"){
//                            guard let groupMemberId:String = value as? String else{return}
//                            if !groupMemberId.isEmpty{
//                                
//                                /////Update Chat Table after sending media successfully
//                                NewChatConversationViewModel.instance.getLastMessageOfConversationForGroup1(grpMember:groupMemberId, groupName:toEmpName as? String ?? "", lastMsg:dataObj.payload ?? "", MsgType:dataObj.message_type ?? "",  isNotifyMessage:"no", messageKey:dataObj.messageKey ?? "", messageFor: "", actionPerformedOnUserId: ""){ (success) in
//                                    if success{
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }else{
//                let firstNameIs = UserDefaults.standard.value(forKey: "FirstName") as! [String]
//                let fromUserFullName = firstNameIs.first!.getFullName(lastName: (UserDefaults.standard.value(forKey: "LastName") as? [String])!)
//                let fromEmpName = fromUserFullName
//                guard let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") as? String else {return}
//                //guard let currentEmpID = UserDefaults.standard.value(forKey: "EmployeeId") as? [Int] else{ return }
//                let currentEmpID = Preferences.employeeId ?? 0
//                guard let toEmpID = UserDefaults.standard.value(forKey: "ToEmployeeId") else{ return }
//                
//                ////update message table after sending media successfully
//                let MessageKeySentReferaneceSender = FirebaseService.instance.databaseMessages().child(currentUserId as! String).child(toUsreId as! String).child(CurrentMsgKey)
//                let MessageKeySentReferaneceReceiver = FirebaseService.instance.databaseMessages().child(toUsreId as! String).child(currentUserId as! String).child(CurrentMsgKey)
//                let message = ["isFileUploadedOnAWS": true, "deliverd_status": Constant.encryptedKeys.deliveryStatus2, "timeStamp": ServerValue.timestamp()] as [String : Any]
//                MessageKeySentReferaneceSender.updateChildValues(message)
//                MessageKeySentReferaneceReceiver.updateChildValues(message)
//                
//                ////notification send after msg sent status
//                let companyId = (UserDefaults.standard.value(forKey: "CompanyId") as? [Int])?.first
//                let notificationpayload = ["from": currentUserId, "type": "0", "companyId": companyId] as [String : Any]
//                let notificationRef = FirebaseService.instance.databaseNotification().child(toUsreId as! String).child(CurrentMsgKey)
//                notificationRef.setValue(notificationpayload)
//                
//                /////Update Chat Table after sending media successfully
//                NewChatConversationViewModel.instance.getLastMessageOfConversationForSingleChat1(currentUserId: currentUserId as! String, toUsreId: toUsreId as! String, toEmpName:toEmpName, toEmpId:"\(toEmpID)", lastMsg:dataObj.payload ?? "", MsgType:dataObj.message_type ?? "", msgsCount:msgsArrCount, messageKey:dataObj.messageKey ?? ""){ (success) in
//                    if success{
//                    }
//                }
//                //NewChatConversationViewModel.instance.getLastMessageOfConversationForSingleChat1(currentUserId: toUsreId as! String , toUsreId: currentUserId as! String, toEmpName:fromEmpName, toEmpId:String(currentEmpID.first!), lastMsg:dataObj.payload ?? "", MsgType:dataObj.message_type ?? "", msgsCount:msgsArrCount, messageKey:dataObj.messageKey ?? ""){ (success) in
//                NewChatConversationViewModel.instance.getLastMessageOfConversationForSingleChat1(currentUserId: toUsreId as! String , toUsreId: currentUserId as! String, toEmpName:fromEmpName, toEmpId:String(currentEmpID), lastMsg:dataObj.payload ?? "", MsgType:dataObj.message_type ?? "", msgsCount:msgsArrCount, messageKey:dataObj.messageKey ?? ""){ (success) in
//                    if success{
//                    }
//                }
//            }
//        }
//    }
//    
//    fileprivate func showPopupWithOkButtonOnly(withMessage message:String, cancelTitle:String, actionTitle: String, actionTag: Int, isActionButton: Bool) {
//        
//        let screenRect = UIScreen.main.bounds;
//        let viewFrame:CGRect = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
//        let confirmationPopup: ConfirmationPopupMessage = ConfirmationPopupMessage(frame: viewFrame, message: message, canceltitle:cancelTitle, actiontitle:actionTitle ,actionButtonTag:actionTag,isActionButton:isActionButton, showOkButtonOnly: true)
//        confirmationPopup.delegate = self
//        confirmationPopup.confirmationImageView.image = UIImage(named: "errorWarningIllustration")!
//        
//        UIApplication.shared.keyWindow!.addSubview(confirmationPopup)
//    }
//    
//    @objc fileprivate func removeSubView(){
//           
//        for view in  UIApplication.shared.keyWindow?.subviews ?? [] {
//            if view is ConfirmationPopupMessage{
//                view.removeFromSuperview()
//            }
//        }
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        generateAccessibilityIdentifiers()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

//MARK: - ConfirmationPopupMessage Delegate Methods

//extension PhotoSenderTableViewCell: ConfirmationPopupMessageDelegate {
//
//    func popupCancelButtonClick() {
//
//        self.removeSubView()
//    }
//
//    func popActionButtonClick(tag: Int) {
//
//        self.removeSubView()
//
//    }
//}

