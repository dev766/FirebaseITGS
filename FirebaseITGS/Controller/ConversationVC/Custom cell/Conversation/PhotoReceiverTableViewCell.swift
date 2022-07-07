//
//  PhotoReceiverTableViewCell.swift
//  PeopleHr
//
//  Created by It Gurus Software on 26/02/19.
//  Copyright © 2019 iT Gurus Software. All rights reserved.
//

import UIKit
import Photos

class PhotoReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var backShadowView: shadowView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userNameLblHeight: NSLayoutConstraint!
    @IBOutlet weak var receiverBackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadImgView: ITGSVGViewer!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var cornerView: UIView!

    
    var dataObj: Message!
    
    let defaults = UserDefaults.standard
    var currentIndexPathRow:Int?
    var isDownloaded: Bool = false
    var viewController: UIViewController?
    var pngImageData: Data?
    var offlineImageDataBeforeDownload: Data?
    var isDownloadingStarted: Bool = false
    var mediaOfflineUrlIfExist:String?
    
    var cellTable:UITableView?
    var currentIndexPath:IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageImageView.image = nil
    }
    
    func setupUI(dataObj: Message, previousdataObj: Message, msgKey:String, userProfile:String, groupMembers:[EmployeeDetailsList], isGroupConv:Bool?, indexPath: IndexPath, table: UITableView)
    {
        self.showHideLoadinggActivityIndicator(showLoader: false)
        self.cellTable = table
        self.currentIndexPath = indexPath
        self.currentIndexPathRow = indexPath.row
        self.dataObj = dataObj
        
        if let message = dataObj.payload {
            if message != ""{
//                let imageURL = URL(string: message)
//                let fileName = imageURL?.lastPathComponent as NSString? ?? ""
//                let predicate = NSPredicate(format: "messagekey = %@", fileName)
//                if let offlineURLs = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], offlineURLs.count != 0 {
//                    print("found value in DB")
//                    self.mediaOfflineUrlIfExist = offlineURLs.first!.mediaOfflineURL
//                    let imageData = offlineURLs.first!.imageData
//                    DispatchQueue.main.async {
//                        self.showHideLoadinggActivityIndicator(showLoader: false)
//                        self.isDownloaded = true
//                        self.downloadView.isHidden = true
//                        self.downloadImgView.isHidden = true
//                    }
//                    self.messageImageView.image = UIImage(data: imageData!)
//                    self.messageImageView.contentMode = .scaleAspectFill
//
//                    if self.currentIndexPathRow != nil{
//                        var isDownloadingForRowArray = self.defaults.stringArray(forKey: "SavedIndexPathArray") ?? [String]()
//                        isDownloadingForRowArray.removeAll(where: {$0 == "\(self.currentIndexPathRow!)"})
//                        self.defaults.set(isDownloadingForRowArray, forKey: "SavedIndexPathArray")
//                    }
//                }else{
////                    DispatchQueue.global(qos: .background).async {
//                        DispatchQueue.main.async {
//                            if let cell = table.cellForRow(at: indexPath) as? PhotoReceiverTableViewCell{
//                                if cell.isDownloadingStarted{
//                                    cell.downloadImgView.isHidden = true
//                                    cell.showHideLoadinggActivityIndicator(showLoader: true)
//                                }else{
//                                    cell.showHideLoadinggActivityIndicator(showLoader: false)
//                                    cell.isDownloaded = false
//                                    cell.downloadView.isHidden = false
//                                    cell.downloadImgView.isHidden = false
//                                    cell.downloadImgView.setSVGWithId("downloadChat", withColor: UIColor.init(hexString: "D2D2D5"))
//                                }
//                            }
//                        }
////                    }
//
//                    let downloadedMediaPredicate = NSPredicate(format: "mediaKey = %@", fileName)
//                    if let downloadedMedia = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.MediaPreviewDetails, in: CoreDataManager.sharedManager.backgroundContext, with: downloadedMediaPredicate) as? [MediaPreviewDetails], downloadedMedia.count != 0 {
//                        if downloadedMedia.first!.mediaData != nil{
//                            if let cell = table.cellForRow(at: indexPath) as? PhotoReceiverTableViewCell{
//                                cell.messageImageView.image = UIImage(data: downloadedMedia.first!.mediaData!)
//                            }
//                            self.messageImageView.contentMode = .scaleAspectFill
//                        }
//                    }else{
//                        let mediaUrl = URL(string:message)
//                        DispatchQueue.global().async {
//                            Util.replaceImageUrlWithPreSignedUrl(link: message){
//                                (preSignedUrl,preSignedStr) in
//
//                                if let data = try? Data(contentsOf: preSignedUrl)
//                                {
//                                    let image: UIImage = UIImage(data: data)!
//                                    self.offlineImageDataBeforeDownload = image.jpeg(.lowest)
//                                    DispatchQueue.main.async {
//                                        if let cell = table.cellForRow(at: indexPath) as? PhotoReceiverTableViewCell{
//                                            cell.messageImageView.image = UIImage(data: self.offlineImageDataBeforeDownload!)
//                                            cell.messageImageView.contentMode = .scaleAspectFill
//                                        }
//                                    }
//
//                                    if let managedObj = CoreDataHandler.insertObject(forEntity: Constant.CoreDataEntity.MediaPreviewDetails, in: CoreDataManager.sharedManager.backgroundContext) as? MediaPreviewDetails{
//                                        managedObj.mediaOfflineURL = message
//                                        managedObj.mediaData = self.offlineImageDataBeforeDownload
//                                        managedObj.mediaKey = mediaUrl?.lastPathComponent
//                                        CoreDataManager.sharedManager.saveBackgroundContextAsync()
//                                    }
//                                }
//                            }
//
//                        }
//                    }
//                }
            }
        }
            
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.clipsToBounds = true
        if isGroupConv ?? false{
            userNameLblHeight.constant = 21
            userNameLblBottomConstraint.constant = 5
            userNameLabel.isHidden = false
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
        
        cellButton.layer.setValue(indexPath.row, forKey: "indexPath")
        cellButton.addTarget(self, action: #selector(cellButtonTapped), for: .touchUpInside)
        
        guard let time = dataObj.timeStamp else {return}
        let timeStampStr:String = time.stringValue
        guard let prevTime = previousdataObj.timeStamp else {return}
        let prevTimeStampStr:String = prevTime.stringValue
        let prevTimemy = prevTimeStampStr.dateFromMilliseconds(format: prevTimeStampStr ?? "")
        
        let endTimemy = timeStampStr.dateFromMilliseconds(format: timeStampStr ?? "")
        let interval = endTimemy!.timeIntervalSince(prevTimemy!)
        let duration = Int(interval)
        let durationMinutes = (duration / 60) % 60
        //        print(interval,duration,durationMinutes)
        
        /////add 20px spacing for oppsite type(receiver) cell
        if dataObj.from_id != previousdataObj.from_id{
            self.receiverBackViewTopConstraint.constant = 20
        }else{
            self.receiverBackViewTopConstraint.constant = 5
        }
        ///if messages from sender within 5 minutes
//        if durationMinutes < 1 && indexPath.row != 0 && dataObj.from_id == previousdataObj.from_id /*&& previousdataObj.isFileUploadedOnAWS == true*/{
//            timeLabel.isHidden = true
//            timeLblHeight.constant = 0
//            self.userImageView.isHidden = true
//            
//        }else{
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
    
    func showHideLoadinggActivityIndicator(showLoader: Bool){
        if showLoader{
            self.loadingActivity.startAnimating()
            self.loadingActivity.isHidden = false
        }else{
            self.loadingActivity.stopAnimating()
            self.loadingActivity.isHidden = true
        }
    }
    
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
    
    @objc func cellButtonTapped(sender: UIButton){
        print("cell button taped")
        
//        if isDownloaded{
//            let vc = PhotoDetailViewController()
//            vc.mediaOfflineURLToShare = self.getOfflineMediaData(payload: self.dataObj.payload ?? "")
//            vc.senderName = dataObj.from_name
//            vc.image = messageImageView.image
//            if vc.image == nil && vc.imageUrl == nil {
//                return
//            }
//            let navigationVc = UINavigationController(rootViewController: vc)
//            navigationVc.modalPresentationStyle = .fullScreen
//            viewController?.navigationController?.present(navigationVc, animated: true, completion: nil)
//        }else{
//            if NetworkHandler.sharedInstance.checkInternetAndShowAlert() == true{
//                self.checkForPhotoPermission()
//            }else{
////                Util.presentAlert(titleMessage: "", message: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, VC: self.viewController!)
//                showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.downloadingImageErrorMsg.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)
//
//            }
//        }
    }
    
    
//    func SaveMediaToLocalDbAndDevice(){
//        DispatchQueue.main.async {
//            self.showHideLoadinggActivityIndicator(showLoader: true)
//            self.downloadImgView.isHidden = true
//        }
//
//        DispatchQueue.global(qos: .background).async {
//            self.isDownloadingStarted = true
//
//            /////Add indexpath where sattred downloading on media
//            if self.currentIndexPathRow != nil{
//                var isDownloadingForRowArray = self.defaults.stringArray(forKey: "SavedIndexPathArray") ?? [String]()
//                isDownloadingForRowArray.append("\(self.currentIndexPathRow!)")
//                self.defaults.set(isDownloadingForRowArray, forKey: "SavedIndexPathArray")
//            }
//
//            var mediaStr: String = ""
//            Util.replaceImageUrlWithPreSignedUrl(link: self.dataObj.payload ?? ""){
//                (preSignedUrl,preSignedStr) in
//                mediaStr = preSignedStr
//                guard let url = URL(string: mediaStr) else { return }
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    guard
//                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
////                        let mimeType = response?.mimeType, mimeType.hasPrefix("image/jpg"),
//                        let data = data, error == nil,
//                        let image = UIImage(data: data)
//                        else { return }
//                        self.pngImageData = image.jpeg(.lowest)
//                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//                        let filename = NSUUID().uuidString + ".jpg"
//                        let fileUrlDatabase = "\(filename)"
//
//                        let imageURL = URL(string: self.dataObj.payload ?? "")
//                        let fileName = imageURL?.lastPathComponent as NSString? ?? ""
//                        let predicate = NSPredicate(format: "messagekey = %@", fileName)
//                        if let deleteURL = CoreDataHandler.getAllRecords(inEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext, with: predicate) as? [ChatAttachment], deleteURL.count != 0{
//                            for record in deleteURL{
//                                CoreDataHandler.deleteRecord(managedObject: record, in: CoreDataManager.sharedManager.backgroundContext)
//                            }
//                        }
//
//                        if let managedObj = CoreDataHandler.insertObject(forEntity: Constant.CoreDataEntity.chatAttachment, in: CoreDataManager.sharedManager.backgroundContext) as? ChatAttachment{
//                            managedObj.mediaOfflineURL = "\(fileUrlDatabase)"
//                            managedObj.imageData = self.pngImageData
//                            if let amazonStringURL = self.dataObj.payload, let amazonURL = URL(string: amazonStringURL){
//                                managedObj.messagekey = amazonURL.lastPathComponent
//                            }
//                            CoreDataManager.sharedManager.saveBackgroundContextAsync()
//                            DispatchQueue.main.async {
//                                self.isDownloadingStarted = false
//                                self.isDownloaded = true
//                                self.downloadView.isHidden = true
//                                self.downloadImgView.isHidden = true
//                                if let cell = self.cellTable!.cellForRow(at: self.currentIndexPath!) as? PhotoReceiverTableViewCell{
//                                    cell.messageImageView.image = UIImage(data: self.pngImageData!)
//                                    cell.messageImageView.contentMode = .scaleAspectFill
//                                }
//                                self.showHideLoadinggActivityIndicator(showLoader: false)
//                            }
//                            /////remove indexpath id media successfully downloaded
//                            if self.currentIndexPathRow != nil{
//                                var isDownloadingForRowArray = self.defaults.stringArray(forKey: "SavedIndexPathArray") ?? [String]()
//                                isDownloadingForRowArray.removeAll(where: {$0 == "\(self.currentIndexPathRow!)"})
//                                self.defaults.set(isDownloadingForRowArray, forKey: "SavedIndexPathArray")
//                            }
//                        }
//
//                    }.resume()
//            }
//
//        }
//    }
    
    func checkForPhotoPermission(){
        UserDefaults.standard.set("true", forKey: "isSystemAlert")
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                DispatchQueue.main.async {
                    if status == .authorized{
//                        self.SaveMediaToLocalDbAndDevice()
                    } else {
//                        self.viewController?.askForPhotoPermissionMethod()
                    }
                }
            })
        }else{
            if photos == .authorized {
//                self.SaveMediaToLocalDbAndDevice()
            }else{
//                self.viewController?.askForPhotoPermissionMethod()
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
        }
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
    
    fileprivate func showPopupWithOkButtonOnly(withMessage message:String, cancelTitle:String, actionTitle: String, actionTag: Int, isActionButton: Bool) {
        
        let screenRect = UIScreen.main.bounds;
        let viewFrame:CGRect = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
//        let confirmationPopup: ConfirmationPopupMessage = ConfirmationPopupMessage(frame: viewFrame, message: message, canceltitle:cancelTitle, actiontitle:actionTitle ,actionButtonTag:actionTag,isActionButton:isActionButton, showOkButtonOnly: true)
//        confirmationPopup.delegate = self
//        confirmationPopup.confirmationImageView.image = UIImage(named: "errorWarningIllustration")!
        
//        UIApplication.shared.keyWindow!.addSubview(confirmationPopup)
    }
    
//    @objc fileprivate func removeSubView(){
//
//        for view in  UIApplication.shared.keyWindow?.subviews ?? [] {
//            if view is ConfirmationPopupMessage{
//                view.removeFromSuperview()
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//            generateAccessibilityIdentifiers()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


//MARK: - ConfirmationPopupMessage Delegate Methods

//extension PhotoReceiverTableViewCell: ConfirmationPopupMessageDelegate {
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
//
