import UIKit
import FirebaseAuth
import Firebase
import Photos
import FirebaseStorage
import GrowingTextView

class NewChatConversationViewController:UIViewController {
    
//    var chatConversationListViewController2 = ChatConversationListViewController2()
//    var chatConversationViewModel = ChatConversationViewModel()
//    var newGroupChatViewController = NewGroupChatViewController()
    var newChatConversationViewModel = NewChatConversationViewModel()
    var firebaseService = FirebaseService()
    
    var editedWordArray: [String]? = []
    var cursorOffset: Int? = nil
    var isFromAddPeople: String = ""
    var chatArray:[Message]!
    var sectionArray = [String]()
    var messages = [Message]()
    var allMessages = [Message]()
    var allMessagesKeyArr = [String]()
    var messagesKeyArr = [String]()
    var msgReadReferance:DatabaseReference!
    var msgSentReferance:DatabaseReference!
    var readConversationOnBackButtonReferenace:DatabaseReference!
    var msgref:DatabaseReference!
    var MessageRef:DatabaseReference!
    var messageSeenConvRef:DatabaseReference!
    var MessageKeyReadReferanece:DatabaseReference!
    var MessageKeySentReferanece:DatabaseReference!
    var MessageGetDeliverdStatusRef:DatabaseReference!
    var messageRefForReadMessage:DatabaseReference!
    var groupMemberRef:DatabaseReference!
    var groupReferance:DatabaseReference!
    var chatUserRefrance:DatabaseReference!
    var isGroupConversation:Bool? = false
    var isIncludeHistory:Bool? = false
    var groupMembers = [Any]()
    var isgroupMute = false
    var clickedIndex:Int = 0
    var isConvertingSingleChatToGroup:String = ""
    var isGroupTitlevalue:Bool = false
    var existingGroupName:String = ""
    var allMentionedUUIDArr = [Any]()
    var allUserNameString = ""
    var msgDateDict:[Date:[Message]] = [:]
    var dateKeysArr:[Date] = []
    var isMessageSeenByReceiver = ""
    var FirToUserNameFromNotification = ""
    var ProfileImageForSingleUser = ""
    var mediaImagePicker = UIImagePickerController()
    var mediaImagePickerForCamera = UIImagePickerController()
    var audioPlayer: AVAudioPlayer!
    var viewController: UIViewController?
    var comingFrom: String = ""
    var mediaInfo1Str:String = ""
    var mediaInfo2Str:String = ""
    var mediaInfo1StrVariable:String = ""
    var mediaInfo2StrVariable:String = ""
    var clickedAudioButton = false
    var showHalfOfflineMsgSize = false
    var enableSendMsgButton = true
    var didTapOnGif:Bool = false
    var ifKeyboardShow:Bool = false
    
    
    var msgEmpty = Message(timeStamp: 1554965878540, from_id: "", from_name: "", payload: "", mediaInfo1: "", mediaInfo2: "", seen: false, seenMembers: "", message_type: "", deliverd_status: "", isFileUploadedOnAWS: true, messageKey: "")
    
    let textViewMaxHeight: CGFloat = 100
    var lastContentOffset: CGFloat = 0
    var lastContentOffsetY: CGFloat = 0
    var isAddAttachmentViewIsOn: Bool = false

    
    @IBOutlet weak var updatingConversationView: UIView!
    @IBOutlet weak var updatingConversationHeight: NSLayoutConstraint!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var textSendView: UIView!
    @IBOutlet weak var textSendViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewHeightContsraints: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: GrowingTextView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var previewImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var attachmentPreviewView: UIView!
    @IBOutlet weak var attachmentPreviewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var sendMessageButtonView: UIView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var SendMessageImageView: UIImageView!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var updatingConversationLabel: UILabel!
    
    // MARK: - no chat View properties
    @IBOutlet weak var noChatsView: UIView!
    @IBOutlet weak var noSearchChatImageView: UIImageView!
    @IBOutlet weak var noSearchResultLabel: UILabel!
    
    // suggesteduser view variables
    
    @IBOutlet var suggestedUserView: UIView!
    @IBOutlet weak var suggestedUserBackView: shadowView!
    @IBOutlet weak var suggestedLabel: UILabel!
    @IBOutlet weak var suggestedNoUserFoundLabel: UILabel!
    @IBOutlet weak var suggestedUserTableView: UITableView!
    @IBOutlet weak var suggestedUserBacklViewHeight: NSLayoutConstraint!
    @IBOutlet weak var suggestedUserTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var toolBarScrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarScrollViewTrailingContsraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarLeftArrowLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarRightArrowTralingConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarLeftArrow: UIView!
    @IBOutlet weak var toolBarRightArrow: UIView!
    @IBOutlet weak var toolBarLeftWidth: NSLayoutConstraint!
    @IBOutlet weak var toolBarRightwidth: NSLayoutConstraint!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var toolBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarScrollView: UIScrollView!
    @IBOutlet weak var addToolbarButton: UIButton!
    
    @IBOutlet weak var MediaDetailParentView: UIView!
    @IBOutlet weak var mediaDetailImgView: UIImageView!
    @IBOutlet weak var messageOptionBlurView: UIView!
    @IBOutlet weak var MessageOptionBackView: UIView!
    @IBOutlet weak var messageEditBtn: UIButton!
    @IBOutlet weak var messageDeleteBtn: UIButton!
    @IBOutlet weak var messageOptionLineView: UIView!
    
    let button = UIButton()
    var barButtonItem = UIBarButtonItem()

    
    
    
    var pngImageData: Data?
    var gifDCIMUrl: URL?
    var imageUrl: URL?
    var gifUrl: URL?
    var videoUrl: URL?
    var audioUrl: URL?
    var audioTimer: Timer!
    var selectedAudioIndexPath: IndexPath!
    var attachmentUrl: URL?
    var commentImageName: String?
    var err: NSError? = nil
    var asset: AVURLAsset?
    var imgGenerator: AVAssetImageGenerator?
    var uiFirstFrameImageForVideo: UIImage?
    
    var isEditMessage:Bool = false
    var existingMessage:Message?
    var editDeleteIndexPath: Int?
    var currentIndexPath:IndexPath?
    var employeeModel: User?
    var userObj: ChatConversation?
    var toUserObj: ChatConversation?
    var isFromDropDownVC: Bool? = false
    var isFromAddPeopleVC: Bool? = false
    var isFromNewGroupChat: Bool? = false
    var newGroupName: String?
    var toName:String?
    var popupFor:String = ""
    var popVCFrom:String = ""
    var scrollToTop: Int = 1
    var scrollToTopNumber: Int = 2
    var isInitialLoad: Bool = true
    var isOnlineFlag:Bool = false
    var calWillDisplay:Bool = false
    var isInitialLoadOrNewMessage:Bool = false
    var isNavigateToChatTab : Bool? = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.backgroundColor = UIColor.clear
//        refreshControl.addTarget(self, action:
//            #selector(loadMoreMessages(_:)),
//                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    
    let chatConEmpty = ChatConversation(seen: "", emp_id: "", isfavorite: false, lastmsg: "", isarchived: false, groupid: "", grouptitle: "", grouplastmessage: "", timestamp: 1554965878540, isgroup: false, name: "", message_type: "", online: "", toChatId: "", isread: false, ismute: "false".encryptMessage(), profile_pic: "", from_id: "", isMsgSeenByReceiver:  "", knownAs: "", usersDetailsArr: [], isGroupTitle: false, isremoved: false, message_key: "")

    
    var originalViewFrame: CGRect?
    var newAddedUserList: [EmployeeDetailsList]?
    var newAddedChatNameStr: String?
    var userfilteredData:[EmployeeDetailsList] = []
    var search: String="" // for searchig user
    var suggestedUserData: [EmployeeDetailsList] = [] // selectedUsers array to tag in group
    var currentGroupUsersArray : [EmployeeDetailsList] = []
    //Audio recording properties
//    var voiceRecordView: VoiceRecordView!
//    private var reachability : Reachability!
    var isMessageTableNodeCalled:Bool = false

    // MARK: - View Lift Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInitialization()
        removeObservers()

//        chatListTableView.refreshControl = self.refreshControl
        newChatConversationViewModel.clearNotificationOfToChatUser()
        
        guard let toChatId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
        
        chatListTableView.scrollsToTop = false
        
        messageEditBtn.setTitle("Edit", for: .normal)
        messageDeleteBtn.setTitle("Delete", for: .normal)

        self.messageOptionBlurView.isUserInteractionEnabled = true
        self.messageOptionBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.messageOptionBlurViewTapped)))

        NotificationCenter.default.addObserver(self, selector:
        #selector(hideSuggestedView), name: NSNotification.Name("hideSuggestedView"), object: nil)
        
        isInitialLoadOrNewMessage = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setText()
        self.showButtonEnable(enable: false)

        let isFirstLaunch:String = UserDefaults.standard.value(forKey: "NewChatScreenFirstLaunch") as? String ?? ""
        if isFirstLaunch == "true"{
            showUpdatingConversation(value: true)
        }else{
            showUpdatingConversation(value: false)
        }
        updatingConversationView.layer.cornerRadius = updatingConversationView.bounds.height/2
        
        suggestedLabel.text = "Suggested"
        
        messageTextView.placeholder = "type message"
        messageTextView.maxHeight = messageTextView.bounds.height + 40
        messageTextView.minHeight = 44
//        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        messageTextView.autocorrectionType = .yes
        self.tabBarController?.tabBar.isHidden = true
        // storing original frame of main view
        originalViewFrame = self.view.frame
        
//        tableViewInitialization()

        
        searchBarHeightConstraint.constant = 0 // by default 56
        searchBarViewHeightConstraint.constant = 0 // by default 60
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        

        
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.cornerRadius = 8
        previewImageView.layer.borderColor = UIColor(hexString: "3192DA").cgColor
        previewImageView.layer.borderWidth = 8
        sendMessageButton.addLoaderInView()
        
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        msgReadReferance?.removeAllObservers()
        messageRefForReadMessage?.removeAllObservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        attachmentPreviewView.roundCorners(corners: [.topLeft,.topRight], radius: 25)
    }
    
    func callMessageTable(){
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard UserDefaults.standard.value(forKey: "FirToUserId") != nil else {return}
                        
        ///get chat table changes every time when any action performed by self or others
                        
//        firebaseService.unArchiveChatConversation { (success) in
//            print("Unarchiving Chat Conversation in New Chat Conversation")
            self .loadChatConversation()
//        }
                        
                        
        ////get all messages
        if self.isFromNewGroupChat ?? false{
            self.isGroupConversation = self.userObj?.isgroup ?? true
        }else if self.isFromDropDownVC ?? false{
            self.isGroupConversation = self.userObj?.isgroup ?? false
        }else{
            self.isGroupConversation = self.userObj?.isgroup
        }
                        
                        
        if isFromNewGroupChat ?? false || isGroupConversation ?? false{
            newChatConversationViewModel.loadAllMessagesGroups(){ (mesages,msgKey) in
                self.allMessages = []
                self.allMessagesKeyArr = []
                self.allMessages = mesages
                self.allMessagesKeyArr = msgKey
            }
                            
            newChatConversationViewModel.loadAllMessagesGroupsPagination(scrollToTop:25){ (msgDict,dateKeys,mesages,msgkeys) in
                self.msgDateDict = msgDict
                self.dateKeysArr = dateKeys
                self.messages = []
                self.messagesKeyArr = []
                self.messages = mesages
                self.messagesKeyArr = msgkeys
                                
                                
                self.scrollToTopNumber = 2
                self.isInitialLoad = false
                self.isInitialLoadOrNewMessage = false
                self.showUpdatingConversation(value: false)
                self.isMessageTableNodeCalled = true
    //                    self.showButtonEnable(enable: true)

                self.view.layoutIfNeeded()
                if self.msgDateDict.count > 0{
                    UIView.performWithoutAnimation {
                        DispatchQueue.main.async {
                            self.chatListTableView.reloadData()
                            if self.isEditMessage == false{
                                self.scrollToBottom()
                            }
                            self.buttonEnable()
                        }
                    }
                }
            }
        }else{
            newChatConversationViewModel.loadAllMessages(){ (mesages,msgKey) in
                self.allMessages = []
                self.allMessagesKeyArr = []
                self.allMessages = mesages
                self.allMessagesKeyArr = msgKey
            }
            isOnlineFlag = UserDefaults.standard.bool(forKey: "FirToOnline")
                            
            newChatConversationViewModel.loadAllMessagesPagination(scrollToTop:25){ (msgDict,dateKeys,mesages,msgkeys) in
                self.msgDateDict = msgDict
                self.dateKeysArr = dateKeys
                self.messages = []
                self.messagesKeyArr = []
                self.messages = mesages
                self.messagesKeyArr = msgkeys
                                
                                
                self.scrollToTopNumber = 2
                self.isInitialLoad = false
                self.showUpdatingConversation(value: false)
                self.isMessageTableNodeCalled = true
    //                    self.showButtonEnable(enable: true)

                self.view.layoutIfNeeded()
                UIView.performWithoutAnimation {
                    DispatchQueue.main.async {
                        self.chatListTableView.reloadData()
                        if self.isEditMessage == false{
                            self.scrollToBottom()
                        }
                        self.buttonEnable()
                    }
                }
                                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        UserDefaults.standard.set(false, forKey: "noLongerPopupAlreadyShown")
                
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let groupId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        
        if isFromNewGroupChat ?? false || isGroupConversation ?? false{
            self.groupMemberRef = self.firebaseService.databaseGroupChat().child(currentUserId as! String).child(groupId as! String).child("group_Members")
            self.groupMemberRef.keepSynced(true)
            self.groupMemberRef.observe(.value) { (snapshot) in
                print("groupReferance New Chat Conversation")
                if snapshot.exists() {
                    self.groupMembers.removeAll()
                    self.groupMembers = []
                    for object in snapshot.value as? [NSDictionary] ?? [] {
                        let memberDict:NSMutableDictionary = NSMutableDictionary()
                        for(key,vaule) in object {
                            memberDict.setObject(vaule, forKey: key as! NSCopying)
                        }
                        self.groupMembers.append(memberDict)
                    }
                }else{
                    self.groupMembers.removeAll()
                    self.groupMembers = []
                }
            }
        }else{
            self.groupMembers.removeAll()
            self.groupMembers = []
        }
        
        
        
        setupNavigationThreeDotButton()
        showHalfOfflineMsgSize = false
        
        self.enableUIButtons(enable: true)
        
        
        guard let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") as? String else {return}
        var chatTitleName = ""
        if self.isGroupConversation == true || self.userObj?.isgroup == true{
            chatTitleName = toEmpName.getChatuserName()
        }else{
            chatTitleName = toEmpName
        }
        self.title = chatTitleName
        self.toName = toEmpName
        
        self.tabBarController?.tabBar.isHidden = true

        guard let toChatId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
        if toChatId != ""{
            let email = ""//sss
            let password = ""
            if Auth.auth().currentUser == nil{
                ChatAuthservice.shareInstance.emailLogin(email, password: password, fullName: "", empId: 0, deviceToken: "") { (success, message) in
                    if success {
                        self.firebaseService.unArchiveChatConversation { (success) in
                            if success {
                            }
                            self.callMessageTable()
                        }
                    }
                }
            }else{
                firebaseService.unArchiveChatConversation { (success) in
                    if success {
                    }
                    self.callMessageTable()
                }
            }

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
        
                
        NotificationCenter.default.post(name: NSNotification.Name("Stop at VC1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("Stop at VC2"), object: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name("clear map memory"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("clear map memory2"), object: nil)

        if popVCFrom != "unread"{
            /////Set Current user message as Read
            guard let toChatId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
            if toChatId != ""{
                print("Mark as read")
                ///this is to set read when going back to conversation list and to show that all msgs after previous msgs gets read
                self.setAsRead(userObj: userObj, readFlag:true, seenCount:"0", comingFrom: ""){ (success) in
                    if success {
                    }
                }
            }
        }
        
//        removeKeyBoardObservers()
        UserDefaults.standard.setValue("true", forKey: "NewChatScreenFirstLaunch")
    }
    
    
    //MARK: - Button Enable Disbale Method Setup Method
    func buttonEnable(){
            if self.userObj?.isremoved ?? false{
                self.showButtonEnable(enable: false)
                let alertAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) in
                })
//                let isNoLongerPopupAlreadyShown = UserDefaults.standard.bool(forKey: "noLongerPopupAlreadyShown")
//                if !isNoLongerPopupAlreadyShown{
//                    if let vc = UIApplication.topViewController() as? NewChatConversationViewController{
//                        UserDefaults.standard.set(true, forKey: "noLongerPopupAlreadyShown")
                        
//                        self.showPopupWithOkButtonOnly(withMessage: Constant.AlertMessages.noLongerAvailableInGroup.localizedString, cancelTitle: Constant.AlertButtonNames.okButton.localizedString, actionTitle: "", actionTag: 0, isActionButton: false)

//                    }
//
//                }
                
            }else{
                if isMessageTableNodeCalled{
                    self.showButtonEnable(enable: true)
                }
            }
        }
        
        func showUpdatingConversation(value: Bool){
            if value{
                sendMessageButton.isUserInteractionEnabled = false
                updatingConversationView.isHidden = false
                updatingConversationHeight.constant = 30
            }else{
                sendMessageButton.isUserInteractionEnabled = true
                UserDefaults.standard.setValue("false", forKey: "NewChatScreenFirstLaunch")
                self.updatingConversationView.isHidden = true
                self.updatingConversationHeight.constant = 0
            }
        }
    
        func showButtonEnable(enable: Bool){
                
            if enable{
                self.textSendView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 1
                self.messageTextView.alpha = 1
                self.textSendView.isUserInteractionEnabled = true
                
                self.sendMessageButtonView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 1
                self.SendMessageImageView.alpha = 1
                self.sendMessageButton.alpha = 1
                self.addToolbarButton.alpha = 1
                self.enableSendMsgButton = true
                self.sendMessageButton.isUserInteractionEnabled = true
                self.addToolbarButton.isUserInteractionEnabled = true
                
                self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
                self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = true
                self.navigationItem.rightBarButtonItems = [self.barButtonItem]
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
            }else{
                
                self.textSendView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 0.5
                self.messageTextView.alpha = 0.5
                self.textSendView.isUserInteractionEnabled = false
                
                self.sendMessageButtonView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 0.5
                self.SendMessageImageView.alpha = 0.5
                self.sendMessageButton.alpha = 0.5
                self.addToolbarButton.alpha = 0.5
                self.enableSendMsgButton = false
                self.sendMessageButton.isUserInteractionEnabled = false
                self.addToolbarButton.isUserInteractionEnabled = false
                
                self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.5
                self.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = false
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
            }
        }
    
        func setupNavigationThreeDotButton(){
            button.setImage(UIImage (named: "NavigationMenu"), for: .normal) // otherwise on click image blinks
            button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
            //add function for button
            button.addTarget(self, action: #selector(optionsMenuButtonAction), for: .touchUpInside)
            button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 2, right: 4)
            barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItems = [barButtonItem]
        }
    
    func tableViewInitialization(){
        chatListTableView.separatorStyle = .none
        chatListTableView.register(UINib(nibName:"NotifyMessageTableViewCell" , bundle: nil), forCellReuseIdentifier: "notifyMessageTableViewCell")
        chatListTableView.register(UINib(nibName:"SenderCellTableViewCell" , bundle: nil), forCellReuseIdentifier: "senderCell")
        chatListTableView.register(UINib(nibName:"ReceiverCellTableViewCell" , bundle: nil), forCellReuseIdentifier: "receiverCell")
        chatListTableView.register(UINib(nibName:"ConversationDateTableViewCell" , bundle: nil), forCellReuseIdentifier: "conversationDateCell")
        chatListTableView.register(UINib(nibName:"MemberOfflineMessageTableViewCell" , bundle: nil), forCellReuseIdentifier: "MemberOfflineMessageCell")
        suggestedUserTableView.register(UINib(nibName:"NewChatMemberTableViewCell" , bundle: nil), forCellReuseIdentifier: "NewChatMemberCell")
        
//        if #available(iOS 15.0, *) {
//            self.chatListTableView.sectionHeaderTopPadding = .zero
//            self.suggestedUserTableView.sectionHeaderTopPadding = .zero
//        }
    }
    
    func setText(){
        updatingConversationLabel.text = "  " + "Updating Conversation" + "  "
    }
    
    //MARK: - Network changed Observer
    
    @objc func hideSuggestedView(){
//        self.suggestedUserView.removeFromSuperview() ////if user typed @ and then internet goes off so remove suggested view if already presented
        self.suggestedUserView.isHidden = true
    }
    
    //MARK: - Database methods
    
    
    fileprivate func loadChatConversation(){
        
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUserId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}

        chatUserRefrance = firebaseService.databaseChats1().child(currentUserId as! String).child(toUserId )
        chatUserRefrance.keepSynced(true)
        chatUserRefrance.observeSingleEvent(of: .value) { (snapshot) in
            print("chatUserRefrance in loadChatConversation in new chat view controller")
            if !snapshot.exists() {
                self.chatUserRefrance.removeAllObservers()
                return
            }
            self.newChatConversationViewModel.loadAllFireBaseMessage11InNewChat(snapshot: snapshot.value as! NSDictionary) { (currentConversation) in
                
                guard let toChatId:String =  UserDefaults.standard.value(forKey: "FirToUserId") as? String else {return}
                
                let member = currentConversation
                
                guard let selectedToChatId = member.toChatId else {return}
                if selectedToChatId == toChatId{
                    self.userObj = member
                    UserDefaults.standard.set(member.online, forKey: "FirToOnline")
                    self.isOnlineFlag = UserDefaults.standard.bool(forKey: "FirToOnline")
                }

                
                if self.isFromNewGroupChat ?? false{
                    self.isGroupConversation = self.userObj?.isgroup ?? true
                }else if self.isFromDropDownVC ?? false{
                    self.isGroupConversation = self.userObj?.isgroup ?? false
                }else{
                    self.isGroupConversation = self.userObj?.isgroup
                }
                ////to set group name after add people if group name changed
                guard let firToUserId = self.userObj?.toChatId else{ return }
                guard let firToUserName = self.userObj?.name else{ return }
                let firToEmployeeId = self.userObj?.emp_id
                UserDefaults.standard.setValue(firToUserId, forKey: "FirToUserId")
                UserDefaults.standard.setValue(firToUserName, forKey: "FirToUserName")
                UserDefaults.standard.setValue(firToEmployeeId, forKey: "ToEmployeeId")
                var chatTitleName = ""
                if self.isGroupConversation == true || self.userObj?.isgroup == true{
                    chatTitleName = firToUserName.getChatuserName()
                }else{
                    chatTitleName = firToUserName
                }
                
                self.title = chatTitleName
                self.toName = firToUserName
                    
                DispatchQueue.main.async {
                    self.buttonEnable()
                }
                
            }
//            self.chatUserRefrance.removeAllObservers()
        }
    }
    
    
    //MARK: - Set Message as Read
    
    
    func setAsRead(userObj: ChatConversation?, readFlag:Bool, seenCount:String?, comingFrom: String?, handler: @escaping(_ success: Bool) ->()){
        
        let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
        if currentUserId == "" {
            return
        }
        guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
        if !(toUsreId as? String ?? "").isEmpty{
            ///Update Read flag in ChatConversation
            readConversationOnBackButtonReferenace = firebaseService.databaseChats1().child(currentUserId as! String).child(toUsreId as! String)
            readConversationOnBackButtonReferenace.keepSynced(true)
            readConversationOnBackButtonReferenace.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    if  (snapshot.value as? [String: Any]) != nil{
                        self.readConversationOnBackButtonReferenace = self.firebaseService.databaseChats1().child(currentUserId as! String).child(toUsreId as! String)
                        
                        self.readConversationOnBackButtonReferenace.updateChildValues(["seen":seenCount,
                                                             "isread": readFlag] as [String : Any?] as [AnyHashable : Any])
                        self.readConversationOnBackButtonReferenace.removeAllObservers()
                        handler(true)
                    }
                }else{
                    self.readConversationOnBackButtonReferenace.removeAllObservers()
                    handler(false)
                }
            }
        }
    }

    
    
    
    func setMsgSentStatusIntoCurrent(){

        var isMsgSeenByReceiverFlag = ""
        if Util.shared.checkInternetAndShowAlert() == false{
            isMsgSeenByReceiverFlag = encryptedKeys.deliveryStatus1
        }else{
            isMsgSeenByReceiverFlag = encryptedKeys.deliveryStatus2
        }
        
        if isGroupConversation ?? false || self.userObj?.isgroup ?? false{
            guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
            msgSentReferance = firebaseService.databaseMessages().child("Groups").child(toUsreId as! String)
            msgSentReferance.keepSynced(false)
            msgSentReferance.observeSingleEvent(of: .value) { (snapshot) in
                print("msgSentReferance in setMsgSentStatusIntoCurrent in new chat view controller")
                if snapshot.exists() {
                    if  let userDict = snapshot.value as? [String: Any]{
                        for(key,vaule) in userDict {
                            if let value = vaule as? [String: Any]{
                                self.MessageKeySentReferanece = self.firebaseService.databaseMessages().child("Groups").child(toUsreId as! String).child(key)

                                var deliveryStatus =  ""
                                var deliveryStatusEncrypted = value["deliverd_status"] as? String ?? ""
    //            deliveryStatus = FirebaseService.instance.decryptTextMethodWithFixedIV(text:value["deliverd_status"] as? String ?? "")
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                                    deliveryStatus = "1"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                                    deliveryStatus = "2"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                                    deliveryStatus = "3"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                                    deliveryStatus = "4"
                                }

                                //"timeStamp": value["timeStamp"] as? NSNumber ?? 0,
                                if value["isFileUploadedOnAWS"] as? Bool ?? false && deliveryStatus == "1"{
                                    let message = ["deliverd_status": isMsgSeenByReceiverFlag] as [String : Any]
                                    self.MessageKeySentReferanece.updateChildValues(message)
                                }
                            }
                        }
                    }
                }
            }
        }else{
            let currentUserId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
            if currentUserId == "" {
                return
            }
            guard let toUsreId =  UserDefaults.standard.value(forKey: "FirToUserId") else {return}
            msgSentReferance = firebaseService.databaseMessages().child(currentUserId as! String).child(toUsreId as! String)
            msgSentReferance.keepSynced(false)
            msgSentReferance.observeSingleEvent(of: .value) { (snapshot) in
                print("msgSentReferance in setMsgSentStatusIntoCurrent in new chat view controller")
                if snapshot.exists() {
                    if  let userDict = snapshot.value as? [String: Any]{
                        for(key,vaule) in userDict {
                            if let value = vaule as? [String: Any]{
                                self.MessageKeySentReferanece = self.firebaseService.databaseMessages().child(currentUserId as! String).child(toUsreId as! String).child(key)

                                var deliveryStatus =  ""
                                var deliveryStatusEncrypted = value["deliverd_status"] as? String ?? ""
    //            deliveryStatus = FirebaseService.instance.decryptTextMethodWithFixedIV(text:value["deliverd_status"] as? String ?? "")
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus1 || deliveryStatusEncrypted == "1"{
                                    deliveryStatus = "1"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus2 || deliveryStatusEncrypted == "2"{
                                    deliveryStatus = "2"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus3 || deliveryStatusEncrypted == "3"{
                                    deliveryStatus = "3"
                                }
                                if deliveryStatusEncrypted == encryptedKeys.deliveryStatus4 || deliveryStatusEncrypted == "4"{
                                    deliveryStatus = "4"
                                }
                                
                                //"timeStamp": value["timeStamp"] as? NSNumber ?? 0,
                                if value["isFileUploadedOnAWS"] as? Bool ?? false && deliveryStatus == "1"{
                                    let message = ["deliverd_status": isMsgSeenByReceiverFlag] as [String : Any]
                                    self.MessageKeySentReferanece.updateChildValues(message)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
// MARK: - Custom Methods
    
    func scrollToBottom() {
        
        if isGroupConversation ?? false || self.userObj?.isgroup ?? false{
            if(msgDateDict.count>0)
            {
                let lastItem = IndexPath(row: msgDateDict[dateKeysArr.last!]!.count - 1, section: dateKeysArr.count-1)
                if (self.chatListTableView.numberOfSections > lastItem.section && self.chatListTableView.numberOfRows(inSection: lastItem.section) > lastItem.row ) {
                    self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
                }
                if lastItem.row < msgDateDict[dateKeysArr.last!]!.count{
                    /*@try {
                        self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
                    }
                    @catch ( NSException *e )
                    {
                        NSLog(@"bummer: %@",e);
                    }*/
                    
//                    DispatchQueue.main.async {
//                        self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
//                    }
                }
            }
        }else{
            if userObj?.online == "true" || isOnlineFlag{
                if(msgDateDict.count>0)
                {
                    let lastItem = IndexPath(row: msgDateDict[dateKeysArr.last!]!.count - 1, section: dateKeysArr.count-1)
                    if (self.chatListTableView.numberOfSections > lastItem.section && self.chatListTableView.numberOfRows(inSection: lastItem.section) > lastItem.row ) {
                        self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
                    }
                }
            }else{
                if showHalfOfflineMsgSize{
                    if(msgDateDict.count>0)
                    {
                        let lastItem = IndexPath(row: msgDateDict[dateKeysArr.last!]!.count - 1, section: dateKeysArr.count-1)
                        if (self.chatListTableView.numberOfSections > lastItem.section && self.chatListTableView.numberOfRows(inSection: lastItem.section) > lastItem.row ) {
                            self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
                        }
                    }
                }else{
                    if(msgDateDict.count>0)
                    {
                        let lastItem = IndexPath(row: 0, section: dateKeysArr.count)
                        if (self.chatListTableView.numberOfSections > lastItem.section && self.chatListTableView.numberOfRows(inSection: lastItem.section) > lastItem.row ) {
                            self.chatListTableView.scrollToRow(at: lastItem, at: .bottom, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    func removeObservers(){
        MessageKeyReadReferanece?.removeAllObservers()
        msgSentReferance?.removeAllObservers()
        MessageKeySentReferanece?.removeAllObservers()
//        firebaseService.messageRefSender?.removeAllObservers()
        
        newChatConversationViewModel.messageRefSenderTestChildChangedForSingle?.removeAllObservers()
        newChatConversationViewModel.messageRefSenderTestForSingle?.removeAllObservers()
        newChatConversationViewModel.messageRefSenderPagingForSingle?.removeAllObservers()
        newChatConversationViewModel.messageRefPreviousStructureForGroup?.removeAllObservers()
        newChatConversationViewModel.messageRefSenderForGroup?.removeAllObservers()
        newChatConversationViewModel.messageRefSenderPagingForGroup?.removeAllObservers()
    }
        
    func getSuggestedTableViewHeight(rows:Int){
        let suggestedUserTableViewHeightIs = rows * Int(50)
        self.suggestedUserTableViewHeight.constant = CGFloat(suggestedUserTableViewHeightIs)
        self.suggestedUserBacklViewHeight.constant = CGFloat(suggestedUserTableViewHeightIs)
    }
    
    
        
    func enableDisableSendButton(enable: Bool)
    {
        if enable {
            sendMessageButton.removeLoader()
            sendMessageButton.isUserInteractionEnabled = true
            sendMessageButtonView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 1
            SendMessageImageView.alpha = 1
        } else {
            sendMessageButton.showLoader()
            sendMessageButton.isUserInteractionEnabled = false
            sendMessageButtonView.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.alpha = 0.0
            SendMessageImageView.alpha = 0
        }
    }
    
    func enableUIButtons(enable: Bool){
        if enable{
            self.attachmentPreviewView.isUserInteractionEnabled = true
            self.toolBarView.isUserInteractionEnabled = true
        }else{
            self.attachmentPreviewView.isUserInteractionEnabled = false
            self.toolBarView.isUserInteractionEnabled = false
        }
    }
        
    // MARK: - IBOutlet Methods
    
    @IBAction func addToolbarButtonAction(_ sender: Any) {
        
        if enableSendMsgButton{
            //        showtoolBarRightArrow()
            //        toolBarScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            //        UIView.animate(withDuration: 0.2) {
            if let button = sender as? UIButton {
                button.isSelected = !button.isSelected
                if button.isSelected {
                    showHideMediaToolBarView(value: true)
                } else {
                    showHideMediaToolBarView(value: false)
                }
            }
        }
    }
    
    func showHideMediaToolBarView(value: Bool){
        if value {
            // set deselected
            addToolbarButton.setImage(UIImage(named: "removeMedia"), for: .normal)
            //  addToolbarButton.setBackgroundImage(UIImage(named: "removeMedia"), for: .normal)
            //  addToolbarImageView.setSVGWithId("minus", withColor: UIColor.white)
            toolBarView.isHidden = false
            toolBarViewHeightConstraint.constant = 69
            toolBarTopConstraint.constant = 0
            if imageUrl != nil || gifUrl != nil || videoUrl != nil{
                blurView.isHidden = false
                attachmentPreviewView.isHidden = false
            }
        } else {
            // set selected
            //  addToolbarImageView.setSVGWithId("plus", withColor: UIColor.white)
            addToolbarButton.setImage(UIImage(named: "AddMedia"), for: .normal)
            // addToolbarButton.setBackgroundImage(UIImage(named: "AddMedia"), for: .normal)
            toolBarView.isHidden = true
            toolBarViewHeightConstraint.constant = 0
            toolBarTopConstraint.constant = 10
            blurView.isHidden = true
            attachmentPreviewView.isHidden = true
        }
        self.view.layoutSubviews()
        self.attachmentPreviewView.layoutIfNeeded()
    }
    
    @IBAction func sendButtonAction(_ sender: Any){
        
        if enableSendMsgButton{
            self.isInitialLoadOrNewMessage = false
            scrollToTop = 1
            scrollToTopNumber = 2
            isInitialLoad = true
            sendMessage(messageType:"text",mediaMsg:"", isFileUploadedOnAWS: true)
        }
    }
        
    
    func sendMessage(messageType:String,mediaMsg:String,isFileUploadedOnAWS:Bool){
        showHalfOfflineMsgSize = true

        let email = ""//sss
        let password = ""
        if Auth.auth().currentUser == nil{
            ChatAuthservice.shareInstance.emailLogin(email, password: password, fullName: "", empId: 0, deviceToken: "") { (success, message) in
                if success {
                    self.sendMessageAftercheckingAuthUser(messageType:messageType,mediaMsg:mediaMsg, isFileUploadedOnAWS: isFileUploadedOnAWS)
                }
            }
        }else{
            self.sendMessageAftercheckingAuthUser(messageType:messageType,mediaMsg:mediaMsg, isFileUploadedOnAWS: isFileUploadedOnAWS)
        }
    }
    
    func sendMessageAftercheckingAuthUser(messageType:String,mediaMsg:String,isFileUploadedOnAWS:Bool){
        if self.existingMessage == nil{
            self.isEditMessage = false
        }
        self.suggestedUserData.removeAll()
        if isFromNewGroupChat ?? false || isGroupConversation ?? false || self.userObj?.isgroup ?? false{
            if mediaMsg != ""{
                newChatConversationViewModel.sendGroupMessage(allMentionedUUIDArrary: allMentionedUUIDArr, msgToSend: mediaMsg.encryptMessage() ?? "" , messageFor:"normalMsg", actionPerformedOnUser:"", actionPerformedOnUserId:"", renamedGroupName:"", previousGroupName:"", groupMember:self.groupMembers, isNotifyMessage:"no", messageType:messageType, mediaInfo1: mediaInfo1StrVariable, mediaInfo2: mediaInfo2StrVariable,isFileUploadedOnAWS: isFileUploadedOnAWS){
                    _ in
                }
            }
            let msgText = (self.messageTextView.text)?.trimmingCharacters(in: NSCharacterSet.whitespaces)
            if messageTextView.text != "" && msgText != ""{
                 let encryptedmessage:String? = messageTextView.text.encryptMessage()
                if self.isEditMessage{
                    if self.existingMessage != nil{
                        newChatConversationViewModel.editMessageForGroup(allMentionedUUIDArrary:allMentionedUUIDArr, groupMember:self.groupMembers, msgToSend:encryptedmessage ?? "", existingMsg:self.existingMessage!, isEdit:true, lastMsgKeyFromChatTable:self.userObj?.message_key ?? "")
                    }
                }else{
                    newChatConversationViewModel.sendGroupMessage(allMentionedUUIDArrary: allMentionedUUIDArr, msgToSend: encryptedmessage ?? "", messageFor:"normalMsg", actionPerformedOnUser:"", actionPerformedOnUserId:"", renamedGroupName:"", previousGroupName:"", groupMember:self.groupMembers, isNotifyMessage:"no", messageType:"text", mediaInfo1: mediaInfo1StrVariable, mediaInfo2: mediaInfo2StrVariable, isFileUploadedOnAWS: true){
                        _ in
                    }
                }
            }
            self.resetMessageTextView()
        }else{
            if mediaMsg != ""{//////send media message like image,gif (will not be edited after sending)
                newChatConversationViewModel.sendMessage(msgToSend: mediaMsg.encryptMessage() ?? "", userObject: userObj, messageType:messageType, msgsCount:self.messages.count, mediaInfo1: mediaInfo1StrVariable, mediaInfo2: mediaInfo2StrVariable,isFileUploadedOnAWS: isFileUploadedOnAWS)
            }
            let msgText = (self.messageTextView.text)?.trimmingCharacters(in: NSCharacterSet.whitespaces)
            if messageTextView.text != "" && msgText != ""{////////text message (user can able to edit text msg after sending)
                if self.isEditMessage{
                    let encryptedmessage:String? = messageTextView.text.encryptMessage()
                    if self.existingMessage != nil{
                        newChatConversationViewModel.editMessage(msgToSend:encryptedmessage ?? "", existingMsg:self.existingMessage!, isEdit:true, lastMsgKeyFromChatTable: self.userObj?.message_key ?? "")
                    }
                }else{
                    let encryptedmessage:String? = messageTextView.text.encryptMessage()
                    newChatConversationViewModel.sendMessage(msgToSend: encryptedmessage ?? "", userObject: userObj, messageType:"text", msgsCount:self.messages.count, mediaInfo1: mediaInfo1StrVariable, mediaInfo2: mediaInfo2StrVariable,isFileUploadedOnAWS: true)
                }
            }
            self.resetMessageTextView()
        }
        allUserNameString = ""
        allMentionedUUIDArr = []
        self.enableUIButtons(enable: true)
        enableDisableSendButton(enable: true)
    }
    
    func resetMessageTextView(){
        messageTextView.text = ""
        self.existingMessage = nil
    }
    @IBAction func mediaDetailParentViewCloseBtnClicked(_ sender: Any) {
        self.MediaDetailParentView.isHidden = true
    }
    
    
        
    @IBAction func messageEditBtnClicked(_ sender: Any) {
        self.messageTextView.text = self.existingMessage?.payload
        self.isEditMessage = true
        self.messageOptionBlurView.isHidden = true
        self.MessageOptionBackView.isHidden = true
    }
    @IBAction func messageDeleteBtnClicked(_ sender: Any) {
        self.isEditMessage = true

        if self.existingMessage != nil{
            if isFromNewGroupChat ?? false || isGroupConversation ?? false || self.userObj?.isgroup ?? false{
                newChatConversationViewModel.editMessageForGroup(allMentionedUUIDArrary:[], groupMember:self.groupMembers, msgToSend: "", existingMsg:self.existingMessage!, isEdit:false, lastMsgKeyFromChatTable:self.userObj?.message_key ?? "")
            }else{
                newChatConversationViewModel.editMessage(msgToSend:"", existingMsg:self.existingMessage!, isEdit:false, lastMsgKeyFromChatTable: self.userObj?.message_key ?? "")
            }
            self.messageOptionBlurView.isHidden = true
            self.MessageOptionBackView.isHidden = true
        }else{
            print("error in deleteing message")
        }
        self.resetMessageTextView()
    }
    
    
    @IBAction func optionsMenuButtonAction(_ sender: Any) {

    }
    
    @IBAction func imageOrVideoButtonClick(_ sender: Any) {
    }
    
    @IBAction func gifButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func attachmentButtonClick(_ sender: Any) {
    }
    
    @IBAction func audioButtonClick(_ sender: Any) {
    }
    
    @IBAction func locationButtonClick(_ sender: Any) {
        
        
    }
    
    @IBAction func weblinkButtonClick(_ sender: Any) {
    }
    
    
    @IBAction func onPreviewCloseButtonClicked(_ sender: UIButton) {
        self.enableUIButtons(enable: true)
        self.enableDisableSendButton(enable: true)
    }
        
    //MARK: - Scrolling Method
    
    @IBAction func scrollLeftButtonAction(_ sender: Any) {
    }
    
    @IBAction func scrollRightButtonAction(_ sender: Any) {

    }
    func showtoolBarLeftArrow(){
        toolBarRightArrow.isHidden = true
        toolBarLeftArrowLeadingConstraint.constant = 20
        toolBarRightArrowTralingConstraint.constant = 0
        toolBarLeftWidth.constant = 10
        toolBarRightwidth.constant = 0

        //        toolBarScrollViewTrailingContsraint.constant = -10
        toolBarLeftArrow.isHidden = false
//        toolBarScrollViewLeadingConstraint.constant = 10
    }
    func showtoolBarRightArrow(){
        toolBarLeftArrowLeadingConstraint.constant = 0
        toolBarRightArrowTralingConstraint.constant = 20
        toolBarLeftWidth.constant = 0
        toolBarRightwidth.constant = 10

        toolBarLeftArrow.isHidden = true
//        toolBarScrollViewLeadingConstraint.constant = -10
        toolBarRightArrow.isHidden = false
//        toolBarScrollViewTrailingContsraint.constant = 10
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == chatListTableView{
            self.calWillDisplay = true
            if chatListTableView.indexPathsForVisibleRows?.count ?? 0 > 0{
                let topVisibleIndexPath:IndexPath = chatListTableView.indexPathsForVisibleRows![0]
                if topVisibleIndexPath.row == 0 && topVisibleIndexPath.section == 0 && calWillDisplay
                {
                    loadMoreMessages2()
                }
            }
            messageTextView.resignFirstResponder()
        }
        self.messageOptionBlurView.isHidden = true
        self.MessageOptionBackView.isHidden = true
    }
    
    //MARK: - Long press on message to edit or delete
    
    @objc func messageOptionBlurViewTapped() {
        self.messageOptionBlurView.isHidden = true
        self.MessageOptionBackView.isHidden = true
    }
        
    func onLongPress(existMsg:Message, editDeleteIndexPath: Int, IndexPath: IndexPath){
        
        if !(self.userObj?.isremoved ?? false) {
            self.existingMessage = existMsg
            self.editDeleteIndexPath = editDeleteIndexPath
            let currentUserFireId = UserDefaults.standard.value(forKey: Constant.UserDefaultKeys.cuurentFirId) as? String
            if self.existingMessage?.from_id != "notifyMsg" {
                let rect = self.chatListTableView.rectForRow(at: IndexPath)
                var point = CGPoint(x: rect.midX, y: rect.midY)
                point = self.chatListTableView.convert(point, to: nil)
                
                if self.view.frame.size.height / 2 < point.y{
                    point.y = point.y - 200
                }
                self.MessageOptionBackView.frame = CGRect(x: point.x, y: point.y, width: self.MessageOptionBackView.frame.size.width, height: self.MessageOptionBackView.frame.size.height)
                
                
                if self.existingMessage?.message_type == "0" || self.existingMessage?.message_type == "text" || self.existingMessage?.from_id != currentUserFireId{
                    self.messageEditBtn.isHidden = false
                    self.messageOptionLineView.isHidden = false
                }else{
                    self.messageEditBtn.isHidden = true
                    self.messageOptionLineView.isHidden = true
                }
                self.messageOptionBlurView.isHidden = false
                self.MessageOptionBackView.isHidden = false
            }
        }
    }
    
    // long press to meeting view when single meeting
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer, IndexPath: IndexPath){
            if gestureRecognizer.state == .began {
                
                let rect = self.chatListTableView.rectForRow(at: IndexPath)
                var point = CGPoint(x: rect.midX, y: rect.midY)
                point = self.chatListTableView.convert(point, to: nil)

                self.messageOptionBlurView.isHidden = false
                self.MessageOptionBackView.isHidden = false
                
                if self.view.frame.size.height / 2 < point.y{
                    point.y = point.y - 200 //self.view.frame.size.height / 2
                }
                self.MessageOptionBackView.frame = CGRect(x: point.x, y: point.y, width: self.MessageOptionBackView.frame.size.width, height: self.MessageOptionBackView.frame.size.height)
                
            }
        }

} //END of class

extension Int64 {
    var unsigned: UInt64 {
        let valuePointer = UnsafeMutablePointer<Int64>.allocate(capacity: 1)
        defer {
            valuePointer.deallocate() //deallocate(capacity: 1)
        }
        
        valuePointer.pointee = self
        
        return valuePointer.withMemoryRebound(to: UInt64.self, capacity: 1) { $0.pointee }
    }
}

// MARK: - chat options delegate method
//extension NewChatConversationViewController: chatOptionDelegate {
//    func dissmissedView() {
//    }
//
//    func selectedItem(selectedOption: ChatOptionTypeModel,userObj: ChatConversation?) {
//
//        var notificationsOption = [ChatOptionTypeModel]()
//        let isGroupMute = userObj?.ismute ?? "1".encryptMessage()
//        newChatConversationViewModel.addNotificationOptions(isGroupMute:isGroupMute ){
//            (NOptionsArray) in
//            notificationsOption = NOptionsArray
//        }
//
//        let mainStoryboard = UIStoryboard(name: Constant.StoryBoardIdentifier.chat, bundle: nil)
//        switch selectedOption.cellType {
//        case .addPeople:
//
//            let isGroup = userObj?.isgroup ?? false
//            let isGroup2 = isGroupConversation ?? false
//
//            if isGroup || isGroup2{
//                if let controller = mainStoryboard.instantiateViewController(withIdentifier: Constant.ViewControllerIdentifier.addPeopleViewController) as? AddPeopleViewController {
//                    controller.groupMembers = self.groupMembers
//                    controller.userObj = self.userObj
//                    controller.delegate = self
//                    self.navigationController?.pushViewController(controller, animated: true)
//                }
//            }
//            else{
//                guard let toUserID = UserDefaults.standard.value(forKey: "FirToUserId") else{return}
//                guard let name = UserDefaults.standard.value(forKey: "FirToUserName") else{return}
//                var groupMember:Array = [Any]()
//
//                let groupDict:NSMutableDictionary = [:]
//                groupDict.setValue(toUserID, forKey: "groupMemberId")
//                groupDict.setValue(name, forKey: "name")
//                groupMember.append(groupDict)
//
//                isConvertingSingleChatToGroup = "YES"
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: Constant.StoryBoardIdentifier.chat, bundle: nil)
//                let newGroupChat : NewGroupChatViewController = (mainStoryboard.instantiateViewController(withIdentifier: Constant.ViewControllerIdentifier.newGroupChatViewController) as?  NewGroupChatViewController)!
//                //self.navigationController?.pushViewController(newGroupChat, animated: true)
//                newGroupChat.comingFrom = "addPeople"
//                newGroupChat.delegate = self
//                newGroupChat.groupMembers = groupMember
//                self.present(newGroupChat, animated: true, completion: nil)
//            }
//            break
//        case .markFavorite:
//            print("Mark as Favoutirte")
////            firebaseService.setMarkAsFavourite(userObj: userObj){ (success) in
////                if success {
////                }
////            }
//            break
//        case .mute:
////            print("Mark as Mute")
////            firebaseService.setAsMute(){ (success) in
////                if success {
////                }
////            }
//            break
//        case .markUnread:
//            print("Mark as unread")
////
////            let messageListWithoutNotifiyMsg = self.allMessages.filter({$0.from_id != "notifyMsg"})
////            //guard let loginUserID = UserDefaults.standard.value(forKey: "currentFireUserId") else{return}
////            let loginUserID = Preferences.currentFireUserId ?? ""
////            if loginUserID == "" {
////                return
////            }
////            let receivedMessageList = messageListWithoutNotifiyMsg.filter({$0.from_id != loginUserID as? String ?? ""})
////            if receivedMessageList.count > 0{
////                self.firebaseService.markAsUnread(userObj: self.userObj, readFlag:false, seenCount:"1", comingFrom: "option", comingFromVc: "newChat"){ (success) in
////                    if success {
////                    }
////                    self.popVCFrom = "unread"
////                    self.navigationController?.popViewController(animated: false)
////                }
////            }
//            break
//        case .archive:
//            print("Mark as Archive")
////            firebaseService.setMarkAsArchive(userObj: userObj) { (success) in
////                if success {
////                }
////                self.navigationController?.popViewController(animated: false)
////            }
//            break
//        case .report:
//            break
//        case .removePeople:
//            break
//        case .renameConversation:
//            break
//        case .notificationSetting:
//            break
//        case .leave:
//            break
//        case .allActivity:
//            break
//        case .onlyMentions:
//            break
//        case .muteNotifications:
//            break
//        }
//
//
//    }
//}

// MARK: - UITableView delegate method
extension NewChatConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == chatListTableView {
        
            if isGroupConversation ?? false || self.userObj?.isgroup ?? false{
                return dateKeysArr.count
            }else{
                if userObj?.online == "true" || isOnlineFlag{
                    return dateKeysArr.count
                }
                return dateKeysArr.count + 1
            }
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == chatListTableView {
            if section > dateKeysArr.count-1{
                return 1
            }
            return msgDateDict[dateKeysArr[section]]!.count
        } else {
           return userfilteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == chatListTableView {
            
            if indexPath.section <= dateKeysArr.count-1{
                
                let currentUserFireId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
                if currentUserFireId != ""{
                    if indexPath.row < (msgDateDict[dateKeysArr[indexPath.section]])?.count ?? 0{
                        let fromId = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].from_id
                        
                        var cellType: newChatCellType
                        
                        if fromId == "notifyMsg" {
                            cellType = .notifyMsg
                        }else if fromId == currentUserFireId{
                            cellType = .sender
                        }else{
                            cellType = .receiver
                        }
                        
                        switch cellType {
                            
                        case .notifyMsg:
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: "notifyMessageTableViewCell", for: indexPath) as? NotifyMessageTableViewCell else {return UITableViewCell()}
                            
                            if indexPath.row > 0{
                                if (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].payload != ""{
                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row - 1], msgKey:"", indexPath: indexPath.row)
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    cell.shadowView.isHidden = false
                                    return cell
                                }else{
                                    cell.shadowView.isHidden = true
                                }
                            }else{
                                if (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].payload != ""{
                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], msgKey:"", indexPath: indexPath.row)
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    cell.shadowView.isHidden = false
                                    return cell
                                }else{
                                    cell.shadowView.isHidden = true
                                }
                            }
                            
                        case .sender:
                            
                            if indexPath.row > 0{
                                let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
                                if messageType == "0" || messageType == "text"{
                                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderCellTableViewCell else {return UITableViewCell()}

                                    cell.viewController = self
                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row - 1], msgKey:"", indexPath: indexPath.row, isSeenbyReceiver:self.isMessageSeenByReceiver, isGroupConv:isGroupConversation, currentIndexPath: indexPath)
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    return cell
                                }
                            }else{
                                let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
                                if messageType == "0" || messageType == "text"{
                                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderCellTableViewCell else {return UITableViewCell()}

                                    cell.viewController = self
                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], msgKey:"", indexPath: indexPath.row, isSeenbyReceiver:self.isMessageSeenByReceiver, isGroupConv:isGroupConversation, currentIndexPath: indexPath)
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    return cell
                                }
                            }
                            
                        case .receiver:
                            
                            if indexPath.row > 0{
                                let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
                                if messageType == "0" || messageType == "text"{
                                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as? ReceiverCellTableViewCell else {return UITableViewCell()}

                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row - 1], msgKey:"", userProfile:ProfileImageForSingleUser, groupMembers:self.currentGroupUsersArray, isGroupConv: isGroupConversation, indexPath: indexPath.row)
//                                    cell.viewController = self
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    return cell
                                    
                                }
                            }else{
                                let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
                                if messageType == "0" || messageType == "text"{
                                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as? ReceiverCellTableViewCell else {return UITableViewCell()}

                                    cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], msgKey:"", userProfile:ProfileImageForSingleUser, groupMembers:self.currentGroupUsersArray, isGroupConv: isGroupConversation, indexPath: indexPath.row)
//                                    cell.viewController = self
                                    cell.selectionStyle = .none
                                    cell.layoutSubviews()
                                    return cell
                                }
                            }
                            
                        default:
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderCellTableViewCell else {return UITableViewCell()}

                            if indexPath.row > 0{
                                cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row - 1], msgKey:"", indexPath: indexPath.row,isSeenbyReceiver:self.isMessageSeenByReceiver, isGroupConv:isGroupConversation, currentIndexPath: indexPath)
                            }else{
                                cell.setupUI(dataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], previousdataObj:(msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row], msgKey:"", indexPath: indexPath.row,isSeenbyReceiver:self.isMessageSeenByReceiver, isGroupConv:isGroupConversation, currentIndexPath: indexPath)
                            }
                            cell.layoutSubviews()
                            return cell
                        }
                    }
                }
            }
            let cell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.backgroundView?.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.layoutSubviews()
            return cell
        } else {
            guard let cell = self.suggestedUserTableView.dequeueReusableCell(withIdentifier: "NewChatMemberCell") as? NewChatMemberTableViewCell else {return UITableViewCell()}
            cell.backgroundColor = UIColor.init(hexString: "EAEAEE")
            cell.borderLineView.isHidden = true
            let model = userfilteredData[indexPath.row]

//            cell.setupCell(chatUser: model)
            return cell
        }
       
    }
    
    
    func loadMoreMessages2(){
        refreshControl.endRefreshing()
        if  self.allMessages.count > self.messages.count{
            self.showUpdatingConversation(value: false)
            self.refreshControl.tintColor = UIColor.gray
            
            scrollToTop = 25 * scrollToTopNumber
            if isFromNewGroupChat ?? false || isGroupConversation ?? false || self.userObj?.isgroup ?? false{
                newChatConversationViewModel.loadAllMessagesGroupsPagination(scrollToTop:scrollToTop){ (msgDict,dateKeys,mesages,msgkeys) in
                    self.scrollToTopNumber = self.scrollToTopNumber + 1
                    self.msgDateDict = msgDict
                    self.dateKeysArr = dateKeys
                    self.messages = []
                    self.messagesKeyArr = []
                    self.messages = mesages
                    self.messagesKeyArr = msgkeys
                    
                    
                    self.view.layoutIfNeeded()
                    if self.msgDateDict.count > 0{
                        UIView.performWithoutAnimation {
                            DispatchQueue.main.async {
                                self.chatListTableView.reloadData()
                            }
                        }
                        
                    }
                    self.calWillDisplay = false
                }
            }else{
                newChatConversationViewModel.loadAllMessagesPagination(scrollToTop: scrollToTop){ (msgDict,dateKeys,mesages,msgkeys) in
                    self.scrollToTopNumber = self.scrollToTopNumber + 1
                    self.msgDateDict = msgDict
                    self.dateKeysArr = dateKeys
                    self.messages = []
                    self.messagesKeyArr = []
                    self.messages = mesages
                    self.messagesKeyArr = msgkeys
                    
                    self.view.layoutIfNeeded()
                    if self.msgDateDict.count > 0{
                        UIView.performWithoutAnimation {
                            DispatchQueue.main.async {
                                self.chatListTableView.reloadData()
                            }
                        }
                    }
                    self.calWillDisplay = false
                }
            }
        }else{
            self.calWillDisplay = false
            self.refreshControl.tintColor = UIColor.clear
            
            if enableSendMsgButton{
                self.showUpdatingConversation(value: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == chatListTableView {
            return UITableView.automaticDimension
//            if indexPath.section <= dateKeysArr.count-1{
//                let currentUserFireId:String =  UserDefaults.standard.value(forKey: "currentUserFireId") as? String ?? ""
//                if indexPath.row < (msgDateDict[dateKeysArr[indexPath.section]])?.count ?? 0{
//                    let fromId = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].from_id
//
//                    if fromId == "notifyMsg" {
//                        if indexPath.row > 0{
//                            if (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].payload != ""{
//                                return UITableView.automaticDimension
//                            }else{
//                                return 0
//                            }
//                        }else{
//                            if (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].payload != ""{
//                                return UITableView.automaticDimension
//                            }else{
//                                return 0
//                            }
//                        }
//                    }
//
//
//                    if fromId != currentUserFireId{
//                        let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
//                        if messageType == "image" || messageType == "gif" || messageType == "attachment" || messageType == "audio" || messageType == "video"{
//
//                            if (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].isFileUploadedOnAWS ?? false{
//                                return UITableView.automaticDimension
//                            }else{
//                                return 0
//                            }
//                        }else{
//                            return UITableView.automaticDimension
//                        }
//                    }else{
//                        return UITableView.automaticDimension
//                    }
//                }else{
//                    return 0
//                }
//            }else{
//                return UITableView.automaticDimension
//            }
         }else{
            return 50
         }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == chatListTableView {
            if section > dateKeysArr.count-1{
                return 248
            }
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == chatListTableView {

            if section > dateKeysArr.count-1 {
                guard let noMemberCell = tableView.dequeueReusableCell(withIdentifier: "MemberOfflineMessageCell") as? MemberOfflineMessageTableViewCell else
                {
                    return UITableViewCell()
                }

                noMemberCell.shadowForCornerView()
                noMemberCell.selectionStyle = .none
                let toEmpName = UserDefaults.standard.value(forKey: "FirToUserName") as? String ?? ""
                noMemberCell.offlineMessageLabel.text =  toEmpName + " is currently offline, and will not be alerted right away. If they have all notifications turned off, they will only get your message when they're back online."
                return noMemberCell
            }
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "conversationDateCell") as? ConversationDateTableViewCell else {return UITableViewCell()}

            headerCell.selectionStyle = .none

            let days = Date().daysBetweenDates(startDate: dateKeysArr[section], endDate: Date())
            switch(days){
            case 0:
                headerCell.dateLabel.text = "Today"
            case 1:
                headerCell.dateLabel.text = "yesterday"
            default:
                
                let userDateFormatArray = ["MMM dd, yyyy"]
                let dateString = DateHelper().convertDateFormatter(date: dateKeysArr[section], formatterString: userDateFormatArray.first ?? "MMM dd, yyyy")
                headerCell.dateLabel.text = dateString.uppercased()
            }
            return headerCell
        } else {
            return UITableViewCell()
        }

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if (indexPath.row == 0 || indexPath.row == -1 || indexPath.row == 1) && indexPath.section == 0 && calWillDisplay
        {
           print("Moved to top in willDisplay")
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == chatListTableView {
            if indexPath.section > dateKeysArr.count-1 {
            }else{
                let messageType = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row].message_type
                _ = (msgDateDict[dateKeysArr[indexPath.section]])![indexPath.row]
                
                if messageType == "text" || messageType == "0"{
                    var textValueLbl = ""
                    if let cell = chatListTableView.cellForRow(at: indexPath) as? SenderCellTableViewCell{
                        textValueLbl = cell.messageLabel.text ?? ""
                    }else if let cell = chatListTableView.cellForRow(at: indexPath) as? ReceiverCellTableViewCell{
                        textValueLbl = cell.messageLabel.text ?? ""
                    }
                    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(in: textValueLbl, options: [], range: NSRange(location: 0, length: textValueLbl.utf16.count))
                    
                    for match in matches {
                        guard let range = Range(match.range, in: textValueLbl) else { continue }
                        var urlSting = textValueLbl[range]
                        if urlSting.lowercased().hasPrefix("www."){
                            urlSting = "https://" + urlSting
                        }
                        print(urlSting)
                        //URL(string: urlSting.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                        if let url = URL(string: String(urlSting)), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                }
            }
        } else {
            let selectedUser = self.userfilteredData[indexPath.row]
            allUserNameString = ""
            allMentionedUUIDArr = []
            
            self.suggestedUserData.removeAll(where: { $0.employeeID == selectedUser.employeeID })
            suggestedUserData.append(selectedUser)
            if suggestedUserData.count > 0 {
                for user in suggestedUserData {
                    let fullName = user.firstName?.getFullName(lastName: [user.lastName!])
                    allUserNameString +=  "\(fullName!)" //"@\(fullName!) "
                    allMentionedUUIDArr.append(user.employeeFirebaseUUID ?? "")
                }
            }
            var finalStr2 = ""
            let msgTextIfAny2 = self.messageTextView.text ?? ""
            let fname = selectedUser.firstName?.replacingOccurrences(of: "@", with: "")
            let fullName = fname?.getFullName(lastName: [selectedUser.lastName!])
            finalStr2 = msgTextIfAny2
            let substring = (msgTextIfAny2 as NSString?)?.substring(to: cursorOffset!)
            let editedWord = substring?.components(separatedBy: "@").last
            var str = ""
            if editedWord == ""{
                self.messageTextView.text = (finalStr2 as NSString).replacingCharacters(in: NSRange(location: substring!.count - 1, length: 1), with: "@\(fullName!) ")
                str = (finalStr2 as NSString).replacingCharacters(in: NSRange(location: substring!.count - 1, length: 1), with: "@\(fullName!) ")

            }else{
                let range = finalStr2.range(of: editedWord!)
                self.messageTextView.text = finalStr2.replacingCharacters(in: range!, with: "\(fullName!) ")
                str = finalStr2.replacingCharacters(in: range!, with: "\(fullName!) ")
            }
            print(str)
            ///new added
            self.suggestedUserView.frame = CGRect(x: self.view.frame.origin.x, y: UIScreen.main.bounds.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - textSendView.bounds.size.height)
            self.suggestedUserTableView.scrollsToTop = true
            self.suggestedUserView.removeFromSuperview()
            self.suggestedUserView.isHidden = true
        }
    }
    
    //MARK: - Delegate Methdos -
    
}

// MARK: - TextField delegate Methods

extension NewChatConversationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.suggestedUserView.removeFromSuperview()
        return true
    }

}

// MARK: - TextView delegate Methods

extension NewChatConversationViewController: GrowingTextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        suggestedUserView.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {}
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        suggestedUserView.isHidden = false
        
        let newLength = textView.text!.count + text.count - range.length
        
//        if (newLength % 3 == 0) {
//            GIFKeyboardManager.shared().requestData(textView.text! + text)
//        }
        
        
        if text == ""{
        }
        return true
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        suggestedUserView.isHidden = false
        //print("height: \(height)")
        if textView.text != "" {
            textSendViewHeightConstraints.constant = height + 30
            shadowViewHeightContsraints.constant = height + 10
        } else {
            textSendViewHeightConstraints.constant = 70
            shadowViewHeightContsraints.constant = 50
        }
         self.messageTextView.layoutIfNeeded()
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if isGroupConversation == true || self.userObj?.isgroup == true{
            if let cursorRange = textView.selectedTextRange {
                // get the position one character before the cursor start position
                if let newPosition = textView.position(from: cursorRange.start, offset: -1) {
                    let range = textView.textRange(from: newPosition, to: cursorRange.start)
                    if textView.text(in: range!) == "\n"{
                        self.suggestedUserView.removeFromSuperview()
                        suggestedUserView.isHidden = true
                    }
                    if textView.text(in: range!) == "@"{
                        allMentionedUUIDArr = []
                        allUserNameString = ""
                    }
                    
                    let selectedRange: UITextRange? = textView.selectedTextRange
                    cursorOffset = 0
                    if let aStart = selectedRange?.start {
                        cursorOffset = textView.offset(from: textView.beginningOfDocument, to: aStart)
                    }
                    
                    ////////////////
                    let text = textView.text
                    let text2 = text?.replacingOccurrences(of: "\n", with: " ")
                    let substring = (text2 as NSString?)?.substring(to: cursorOffset!)
                    let searchTextt = substring?.components(separatedBy: "@").last
                    userfilteredData.removeAll()
                    
                    _ = (substring as NSString?)?.substring(from: substring?.count ?? 0 - 1)
                    if substring?.last == "@" || substring?.first == "@" || substring == "@"{
                        let searchTextt2 = "@\(searchTextt ?? "")"
                        let editedWord = substring?.components(separatedBy: " ").last
                        editedWordArray = substring?.components(separatedBy: " ")
                        
                        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
                        if editedWord!.count > 1{
                            let secondLastCharacter = (editedWord! as NSString).substring(with: NSRange(location: editedWord!.count - 2, length: 1))
                            if secondLastCharacter.rangeOfCharacter(from: characterset.inverted) == nil && textView.text(in: range!) == "@" {
                                print("string contains special characters")
                            }else{
                                userfilteredData =  textView.text(in: range!) == "@" ? currentGroupUsersArray : currentGroupUsersArray.filter({ (item) -> Bool in
                                    let fullName = item.firstName?.getFullName(lastName: [item.lastName!])
                                    let value: NSString = fullName! as NSString
                                    return (value.range(of: searchTextt2 , options: .caseInsensitive).location != NSNotFound)
                                })
                            }
                        }else{
                            userfilteredData =  textView.text(in: range!) == "@" ? currentGroupUsersArray : currentGroupUsersArray.filter({ (item) -> Bool in
                                let fullName = item.firstName?.getFullName(lastName: [item.lastName!])
                                let value: NSString = fullName! as NSString
                                return (value.range(of: searchTextt2 , options: .caseInsensitive).location != NSNotFound)
                            })
                        }
                    }
                    
                    if userfilteredData.count > 0 {
                        if userfilteredData.count <= 4{
                            getSuggestedTableViewHeight(rows: userfilteredData.count)
                        }else{
                            getSuggestedTableViewHeight(rows: 4)
                        }
                        DispatchQueue.main.async {
                            self.suggestedUserTableView.reloadData()
                        }
                        if self.ifKeyboardShow{
                            ///new added
                            self.suggestedUserView.frame = CGRect(x: self.view.frame.origin.x, y: UIScreen.main.bounds.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - textSendView.bounds.size.height)
                            self.suggestedUserTableView.scrollsToTop = true
                            suggestedUserView.isHidden = false
                            DispatchQueue.main.async {
                                self.view.addSubview(self.suggestedUserView)
                            }
                        }
                    } else {
                        suggestedUserView.isHidden = true
                        self.suggestedUserView.removeFromSuperview()
                    }
                }else{
                    self.suggestedUserView.removeFromSuperview()
                    suggestedUserView.isHidden = true
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

