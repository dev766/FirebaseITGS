//
//  FirebaseServices.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//
import UIKit

class shadowView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


@IBDesignable
class ContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            let viewHeight:CGFloat = self.frame.height
            self.layer.cornerRadius = viewHeight/2
            self.layer.masksToBounds = true
        }
    }
    @IBInspectable var bgColor: UIColor = UIColor.clear  {
        didSet {
            self.backgroundColor = bgColor
        }
    }
}

class DateContainer: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
class GradientUIView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}

@IBDesignable
class CircularImage: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            let viewHeight:CGFloat = self.frame.height
            self.layer.cornerRadius = viewHeight/2
            self.layer.masksToBounds = true
        }
    }
}

@IBDesignable
class CircularLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            let viewHeight:CGFloat = self.frame.height
            self.layer.cornerRadius = viewHeight/2
            self.layer.masksToBounds = true
        }
    }
}


@IBDesignable
class ChatView: UIView {

    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            let viewHeight:CGFloat = self.frame.height
            self.layer.cornerRadius = viewHeight/2
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    }

    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
}

class tableShadowView: UITableView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //    @IBInspectable
    //    var isMaskBound: Bool = false {
    //        didSet {
    //            layer.masksToBounds = true
    //        }
    //    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable class ITGSVGViewer: UIImageView {

    struct Static {
        static let kFontAwesomeFamilyName = "icomoon"
        static var unicodeStringsOnceToken  = 0
        static var enumDictionaryOnceToken  = 0
        static var fontAwesomeUnicodeStrings = NSArray()
        static var enumDictionary = NSMutableDictionary()
    }
    
    var defaultIconIdentifier : NSString = ""
    var defaultview : UILabel!
    var _identifier : NSString = "Alerts"
    var _color : UIColor = UIColor.white
    
    @IBInspectable public var identifier: NSString
        {
        set (id)
        {
            self._identifier = id
            setSVGWithId(id, withColor: self._color)
        }
        get {
            
            return self._identifier
        }
    }
    
    @IBInspectable public var svgColor: UIColor
        {
        set (color)
        {
            self._color = color
            setSVGWithId(self._identifier, withColor: color)
        }
        get {
            
            return self._color
        }
    }

    
    init() {
        super.init(frame : CGRect.zero)
    }
    
    init(_ : String) {
        super.init(frame:.zero)
        setUpUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        }
    
    private func setUpUI()
    {
        if defaultview != nil
        {
            defaultview.removeFromSuperview()
            defaultview = nil
        }
            defaultview = UILabel()
            defaultview.frame = self.bounds
            defaultview.textAlignment = .center
            defaultview.adjustsFontSizeToFitWidth = true
            //defaultview.minimumScaleFactor = 0.5
            defaultview.baselineAdjustment = .alignCenters
            defaultview.backgroundColor = UIColor.clear
            defaultview.font = UIFont(name: "icomoon", size: self.bounds.size.height )
            //        if UIDevice.current.userInterfaceIdiom == .pad
            //        {
            //            defaultview.font = UIFont(name: "icomoon", size: self.bounds.size.height*2)
            //        }
            self.addSubview(defaultview)
        setSVGWithId(_identifier, withColor: self._color)
    }
    

// mark : Properties

    func SetDefaultIconIdentifier(defaultIconIdentifier : NSString)
    {
        let enums = enumDictionary()
        let result = enums[defaultIconIdentifier] as! NSString
        defaultview.text = result as String
    }
    
    func enumDictionary() -> NSMutableDictionary
    {
        //        dispatch_once(&Static.enumDictionaryOnceToken)
        //            {
        let tmp = NSMutableDictionary()
        
        tmp[SVGEnum.Alerts.rawValue]            = self.fontAwesomeUnicodeStrings().object(at: 0)
        tmp[SVGEnum.Back_Arrow.rawValue]      = self.fontAwesomeUnicodeStrings().object(at: 1)
        tmp[SVGEnum.Bars_HomeIndicator_On_Light.rawValue]      = self.fontAwesomeUnicodeStrings().object(at: 2)
        tmp[SVGEnum.Blue_Line.rawValue]       = self.fontAwesomeUnicodeStrings().object(at: 3)
        tmp[SVGEnum.calendar.rawValue]          = self.fontAwesomeUnicodeStrings().object(at: 4)
        tmp[SVGEnum.Chat.rawValue]   = self.fontAwesomeUnicodeStrings().object(at: 5)
        tmp[SVGEnum.Hamburger.rawValue]          = self.fontAwesomeUnicodeStrings().object(at:6)
        tmp[SVGEnum.Home.rawValue]           = self.fontAwesomeUnicodeStrings().object(at:7)
        tmp[SVGEnum.Icons_Navigation24px_White_BackArrow.rawValue]  = self.fontAwesomeUnicodeStrings().object(at:8)
        tmp[SVGEnum.Lock.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:9)
        tmp[SVGEnum.Material_Light_CheckboxOff.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:10)
        tmp[SVGEnum.Material_Light_CheckboxOn.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:11)
        tmp[SVGEnum.Menu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:12)
        tmp[SVGEnum.Menubar_1.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:13)
        tmp[SVGEnum.message.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:14)
        tmp[SVGEnum.moon_PM.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:15)
        tmp[SVGEnum.Notifications.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:16)
        tmp[SVGEnum.Planner_Blue.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:17)

        tmp[SVGEnum.Plus.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:18)
        tmp[SVGEnum.reason.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:19)
        tmp[SVGEnum.Sun_AM.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:20)
        
        tmp[SVGEnum.Timer_1.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:21)
        tmp[SVGEnum.Timer.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:22)
        tmp[SVGEnum.arrow_point_to_down.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:23)
        tmp[SVGEnum.arrow_point_to_left.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:24)
        tmp[SVGEnum.arrow_point_to_right.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:25)
        tmp[SVGEnum.arrow_point_to_UP.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:26)
        tmp[SVGEnum.minus.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:27)
        tmp[SVGEnum.plus.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:28)
        
        tmp[SVGEnum.Add_chat.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:29)
        tmp[SVGEnum.Add_New.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:30)
        tmp[SVGEnum.Add_people.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:31)
        tmp[SVGEnum.Archive_icon.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:32)
        tmp[SVGEnum.Archive.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:33)
        tmp[SVGEnum.Attachment.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:34)
        tmp[SVGEnum.camera.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:35)
        tmp[SVGEnum.Close.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:36)
        tmp[SVGEnum.Gif.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:37)
        tmp[SVGEnum.Grey_Arrow_Back.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:38)
        tmp[SVGEnum.Group_chat.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:39)
        tmp[SVGEnum.Location.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:40)
        tmp[SVGEnum.Mark_as_favorite.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:41)
        tmp[SVGEnum.mute_volume_interface_symbol.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:42)
        tmp[SVGEnum.Oval_Copy.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:43)
        tmp[SVGEnum.Path_Copy.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:44)
        tmp[SVGEnum.Report.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:45)
        tmp[SVGEnum.Star.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:46)
        tmp[SVGEnum.Video.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:47)
        tmp[SVGEnum.Voicenote_1.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:48)
        tmp[SVGEnum.web_link.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:49)
        tmp[SVGEnum.circle.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:50)
        tmp[SVGEnum.leave.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:51)
        tmp[SVGEnum.toolbar_plus.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:52)
        tmp[SVGEnum.DocumentMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:53)
        tmp[SVGEnum.ExpensesMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:54)
        tmp[SVGEnum.LogoutMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:55)
        tmp[SVGEnum.NewsMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:56)
        tmp[SVGEnum.PulseMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:57)
        tmp[SVGEnum.RippleMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:58)
        tmp[SVGEnum.SettingsMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:59)
        tmp[SVGEnum.ThanksMenu.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:60)
        
        tmp[SVGEnum.expenseLineDelete.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:61)
        tmp[SVGEnum.expenseReportApproved.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:62)
        tmp[SVGEnum.expenseReportDraft.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:63)
        tmp[SVGEnum.expenseReportPaid.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:64)
        tmp[SVGEnum.expenseReportRejected.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:65)
        tmp[SVGEnum.expenseLineReviewPending.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:66)
        tmp[SVGEnum.expenseReportPending.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:67)
        tmp[SVGEnum.plannerRemaining.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:68)
        tmp[SVGEnum.plannerTaken.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:69)
        tmp[SVGEnum.addExpensePhoto.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:70)
        tmp[SVGEnum.renameChatConversation.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:71)
        tmp[SVGEnum.unreadChatMsgs.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:72)
        tmp[SVGEnum.RemovePeopleFromChat.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:73)
        tmp[SVGEnum.sendArrow.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:74)
        tmp[SVGEnum.downloadChat.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:75)
        tmp[SVGEnum.reload.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:76)
        tmp[SVGEnum.markAsRead.rawValue]    = self.fontAwesomeUnicodeStrings().object(at:77)
        Static.enumDictionary = tmp
        //        }
        return Static.enumDictionary
    }
    

    func fontAwesomeUnicodeStrings() -> NSArray
    {
//        dispatch_once(&Static.unicodeStringsOnceToken) {
        
        Static.fontAwesomeUnicodeStrings = ["\u{e900}","\u{e901}","\u{e902}","\u{e904}","\u{e905}","\u{e906}","\u{e907}","\u{e908}","\u{e909}","\u{e90a}","\u{e90b}","\u{e90c}","\u{e90d}","\u{e90e}","\u{e90f}","\u{e910}","\u{e911}","\u{e912}","\u{e913}","\u{e914}","\u{e915}","\u{e916}","\u{e917}","\u{e903}","\u{e918}","\u{e919}","\u{e91a}","\u{e91b}","\u{e91c}","\u{e91d}","\u{e91e}","\u{e91f}","\u{e924}","\u{e925}","\u{e928}","\u{e92a}","\u{e92b}","\u{e935}","\u{e936}","\u{e937}","\u{e938}","\u{e939}","\u{e93d}","\u{e93f}","\u{e941}","\u{e943}","\u{e945}","\u{e948}","\u{e949}","\u{e94b}","\u{e920}","\u{e926}","\u{e931}","\u{e927}","\u{e929}","\u{e92c}","\u{e92d}","\u{e932}","\u{e933}","\u{e934}","\u{e93a}","\u{e93b}","\u{e93c}","\u{e93e}","\u{e940}","\u{e946}","\u{e942}","\u{e944}","\u{e947}","\u{e94a}","\u{e94c}","\u{e94d}","\u{e94e}","\u{e94f}","\u{e921}","\u{e922}","\u{e923}","\u{e92e}"
        ]
     
//        }
        return Static.fontAwesomeUnicodeStrings
    }
    
    
    func setSVGWithId(_  id:NSString,withColor color:UIColor)
    {
        self.image = nil
        self.SetDefaultIconIdentifier(defaultIconIdentifier: id)
        self.defaultview.textColor = color
    }
    func setImageWithoutSVG(_ image : UIImage)
    {
          self.image = image
          defaultview.text = ""
          self.defaultview.textColor = UIColor.clear
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        setUpUI()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

@IBDesignable
class PaddingLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)//CGRect.inset(by:)
        super.drawText(in: rect.inset(by: insets))
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
}

