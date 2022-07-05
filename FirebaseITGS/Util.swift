//
//  Util.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import Foundation
import FirebaseAuth

class Util {
    static let shared = Util()
    
    public func getEncryptionKey() -> String {
        return "FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFe"
    }

}

//MARK:- Auth Services
class ChatAuthservice: NSObject {

    static let shareInstance = ChatAuthservice()
    
    private override init(){}
    
    var username:String?
    var isLoggedIn = false
    var firebaseService = FirebaseService()
    
    func emailLogin(_ email: String, password: String, fullName: String, empId: Int, deviceToken: String, completion: @escaping (_ Success: Bool, _ message: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            print("Firebase error if any ",error as Any)
            let usr = user?.user
            if error != nil || usr == nil{
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
                            if error != nil {
                                completion(false, "Error creating account")
                            } else {
                                guard let firebaseUID = authResult?.user.uid else{
                                    completion(false, "authResult?.user.uid not created")
                                    return
                                }
                                let userRefer = self.firebaseService.databaseUsers().child(firebaseUID)
                                let onlineStatus = "true"
                                let employeeStatus = "1"

                                let userFullNameEncrypt = fullName.encryptMessage()
                                let onlineStatusEncrypt = onlineStatus.encryptMessage()
                                let empIdEncrypt = String(empId).encryptMessage()
                                let employeeStatusEncrypt = employeeStatus.encryptMessage()

                                let userDetails = ["uuid": "\(firebaseUID)", "deviceToken":deviceToken, "isChatNotify":"1", "deviceType": "I", "name": userFullNameEncrypt ?? "", "online":onlineStatusEncrypt ?? "",  "emp_id":empIdEncrypt ?? "", "createdBy": empIdEncrypt ?? "", "employeeStatus": employeeStatusEncrypt ?? "", "knownAs": "", "image":"",  "androidRequireUpdate": "", "createdDtm": "",  "iosRequireUpdate": "", "updatedBy": "", "updatedDtm": "" ] as [String : Any]

                                userRefer.updateChildValues(userDetails)
                                
                                print(firebaseUID)
                                print("Successfully created account")

                            }
                        })
            } else {
                print("FIR user ",user?.user)
                if let usr = user?.user {
                    Auth.auth().updateCurrentUser(usr) { (err) in
                        if err == nil{
                            completion(true, "Successfully Logged In")
                        }
                    }
                }
            }
        })
    }
    
}

enum SVGEnum:NSString {
 
 case   Alerts = "Alerts"
 case   Back_Arrow = "Back_Arrow"
 case   Bars_HomeIndicator_On_Light  = "Bars_HomeIndicator_On-Light"
 case   Blue_Line = "Blue_Line"
 case   calendar = "calendar"
 case   Chat = "Chat"
 case   Hamburger = "Hamburger"
 case   Home = "Home"
 case   Icons_Navigation24px_White_BackArrow = "Icons_Navigation24px_-White_BackArrow"
 case   Lock  = "Lock"
 case   Material_Light_CheckboxOff = "Material-Light-CheckboxOff"
 case   Material_Light_CheckboxOn = "Material-Light-CheckboxOn"
 case   Menu = "Menu"
 case   Menubar_1 = "Menubar_1"
 case   message = "message"
 case   moon_PM  = "moon_PM"
 case   Notifications = "Notifications"
 case   Planner_Blue = "Planner_Blue"
 case   Plus =  "Plus"
 case   reason =  "reason"
 case   Sun_AM =  "Sun_AM"
 case   Timer_1 =  "Timer_1"
 case   Timer =  "Timer"
 case   arrow_point_to_down =  "arrow-point-to-down"
 case   arrow_point_to_left =  "arrow-point-to-left"
 case   arrow_point_to_right =  "arrow-point-to-right"
 case   arrow_point_to_UP =  "arrow-point-to-UP"
 case   minus =  "minus"
 case   plus =  "plus"
 
    case   Add_chat = "Add-chat"
    case   Add_New = "Add-New"
    case   Add_people = "Add-people"
    case   Archive_icon = "Archive-icon"
    case   Archive =  "Archive"
    case   Attachment =  "Attachment"
    case   camera =  "camera"
    case   Close =  "Close"
    case   Gif =  "Gif"
    case   Grey_Arrow_Back =  "Grey---Arrow-Back"
    case   Group_chat =  "Group-chat"
    case   Location =  "Location"
    case   Mark_as_favorite =  "Mark-as-favorite"
    case   mute_volume_interface_symbol = "mute-volume-interface-symbol"
    case   Options = "Options"
    case   Oval_Copy = "Oval-Copy"
    case   Path_Copy = "Path-Copy"
    case   Report =  "Report"
    case   Star =  "Star"
    case   Video =  "Video"
    case   Voicenote_1 =  "Voicenote_1"
    case   web_link =  "web-link"
    case   circle = "circle"
    case   leave = "leave"
    case   toolbar_plus = "toolbar_plus"
    case   DocumentMenu =  "DocumentMenu"
    case   ExpensesMenu =  "ExpensesMenu"
    case   LogoutMenu =  "LogoutMenu"
    case   NewsMenu =  "NewsMenu"
    case   PulseMenu = "PulseMenu"
    case   RippleMenu = "RippleMenu"
    case   SettingsMenu = "SettingsMenu"
    case   ThanksMenu = "ThanksMenu"
    //case  LogbookMenu = "LogbookMenu"
    case expenseLineDelete = "expenseLineDelete"
    case expenseReportApproved = "expenseReportApproved"
    case expenseReportDraft = "expenseReportDraft"
    case expenseReportPaid = "expenseReportPaid"
    case expenseReportRejected = "expenseReportRejected"
    case expenseLineReviewPending = "expenseLineReviewPending"
    case expenseReportPending = "expenseReportPending"
    case plannerRemaining = "plannerRemaining"
    case plannerTaken = "plannerTaken"
    case addExpensePhoto = "addExpensePhoto"
    case renameChatConversation = "renameChatConversation"
    case unreadChatMsgs = "unreadChatMsgs"
    case RemovePeopleFromChat = "RemovePeopleFromChat"
    case sendArrow = "sendArrow"
    case downloadChat = "downloadChat"
    case reload = "reload"
    case markAsRead = "markAsRead"
}

