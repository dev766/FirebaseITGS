//
//  Generic.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import Foundation


// MARK:- Extensions
extension String {
//    func dateFromMilliseconds(format:String) -> Date? {
//        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self)! / 1000.0)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//        dateFormatter.timeZone = TimeZone.current
//        let timeStamp = dateFormatter.string(from: date as Date)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
//        return (formatter.date(from: timeStamp))
//    }
    
    func encryptMessage() -> String? {
        let key = Util.shared.getEncryptionKey()
        let cryptLib = CryptLib()
        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: self, key: key)
        return cipherText
    }

    func decryptMessage() -> String? {
        if self == nil {
            return ""
            
        } else {
            
            let key = Util.shared.getEncryptionKey()
        let cryptLib = CryptLib()
            if let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: self, key: key){
                return decryptedString
            }
        return ""
        }
        return ""
    }
    
    func encryptMessageWithFixedIV() -> String? {
        let key = Util.shared.getEncryptionKey()
        let cryptLib = CryptLib()
        
        let cipherText = cryptLib.encryptPlainText(self, key: key, iv: Util.shared.getEncryptionKey())
        return cipherText
        
    }
    
    func decryptMessageWithFixedIV() -> String? {
        let key = Util.shared.getEncryptionKey()
        let cryptLib = CryptLib()
        
        if let decryptedString = cryptLib.decryptCipherText(self, key: key, iv: Util.shared.getEncryptionKey()){
            return decryptedString
        }
        return ""
    }

}


// MARK:- USER
class User: NSObject {
    
    var UUID: String?
    var deviceToken: String?
    var name: String?
    var online: String?
    var image: String?
    var emp_id: String?
    var isSelected:Bool?
    var deviceType: String?
    var knownAs: String?
    var empStatus: String?
    
    init(UUID: String, deviceToken : String, name : String, online :String , image : String , emp_id:String, isSelected:Bool, deviceType: String, knownAs: String, empStatus: String) {
        self.UUID = UUID
        self.deviceToken = deviceToken
        self.name = name
        self.online = online
        self.image = image
        self.emp_id = emp_id
        self.isSelected = isSelected
        self.deviceType = deviceType
        self.knownAs = knownAs
        self.empStatus = empStatus
    }
}

//MARK:- Message
class Message: NSObject {
    var timeStamp : NSNumber?
    var from_id : String?
    var from_name : String?
    var payload : String?
    var mediaInfo1 : String?
    var mediaInfo2 : String?
//    var seen : String?
    var seen : Bool?
    var seenMembers : String?
    var message_type : String?
    let message_date : Date
    let message_dateStr : String
    let deliverd_status : String?
    let isFileUploadedOnAWS : Bool?
    let messageKey : String?
    
    init(timeStamp : NSNumber, from_id : String, from_name : String, payload :String , mediaInfo1:String, mediaInfo2:String,  seen: Bool, seenMembers:String,  message_type : String, deliverd_status : String, isFileUploadedOnAWS: Bool, messageKey: String) {
        self.timeStamp = timeStamp
        self.from_id = from_id
        self.from_name = from_name
        self.payload = payload
        self.mediaInfo1 = mediaInfo1
        self.mediaInfo2 = mediaInfo2
        self.seen = seen
        self.seenMembers = seenMembers
        self.message_type = message_type
        self.deliverd_status = deliverd_status
        self.isFileUploadedOnAWS = isFileUploadedOnAWS
        self.messageKey = messageKey

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(truncating: self.timeStamp!) / 1000.0)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter1.timeZone = TimeZone.current
        let timeStamp = dateFormatter1.string(from: date as Date)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let strDate = formatter1.date(from: timeStamp)!
        self.message_dateStr = dateFormatter.string(from: strDate)
        
        self.message_date = (self.timeStamp?.stringValue.dateFromMilliseconds(format: (self.timeStamp?.stringValue)!))!
    }
}

//MARK:- ChatConversation
class ChatConversation: NSObject {
    
    var seen:String?
    var emp_id:String?
    var isfavorite:Bool?
    var lastmsg:String?
    var isarchived:Bool?
    var groupid: String?
    var grouptitle: String?
    var grouplastmessage: String?
    var timestamp: NSNumber?
    var isgroup:Bool?
    var name:String?
    var message_type:String?
    var online:String?
    var toChatId:String?
    var isread:Bool?
    var ismute:String?
    var profile_pic: String?
    var from_id:String?
    var isMsgSeenByReceiver:String?
    var knownAs:String?
    var usersDetailsArr:[Any]
    var isGroupTitle:Bool?
    var isremoved:Bool?
    var message_key:String?
    
    init(seen:String?, emp_id:String?, isfavorite:Bool?, lastmsg:String?, isarchived:Bool?, groupid: String?, grouptitle: String?, grouplastmessage: String?, timestamp: NSNumber, isgroup:Bool?, name:String?, message_type:String?, online:String?, toChatId:String?, isread:Bool?, ismute:String?, profile_pic:String?, from_id:String?, isMsgSeenByReceiver:String?,knownAs:String?,usersDetailsArr:[Any], isGroupTitle:Bool?, isremoved:Bool?, message_key:String?) {
        
        self.seen = seen ?? ""
        self.emp_id = emp_id ?? ""
        self.isfavorite = isfavorite ?? false
        self.lastmsg = lastmsg ?? ""
        self.isarchived = isarchived ?? false
        self.groupid = groupid ?? ""
        self.grouptitle = grouptitle ?? ""
        self.grouplastmessage = grouplastmessage ?? ""
        self.timestamp = timestamp
        self.isgroup = isgroup ?? false
        self.name = name ?? ""
        self.message_type = message_type ?? "text"
        self.online = online ?? ""
        self.toChatId = toChatId ?? ""
        self.isread = isread ?? false
        self.ismute = ismute ?? ""
        self.profile_pic = profile_pic ?? ""
        self.from_id = from_id ?? ""
        self.isMsgSeenByReceiver = isMsgSeenByReceiver ?? ""
        self.knownAs = knownAs ?? ""
        self.usersDetailsArr = usersDetailsArr
        self.isGroupTitle = isGroupTitle
        self.isremoved = isremoved
        self.message_key = message_key
    }
}
enum imageType : String {
    case BadgeImage = "1"
    case UserImage
    case noImage
}

class EmployeeDetailsList: Codable {
    let employeeID: Int64?
    let firstName, lastName: String?
    let knownAs: String?
    let jobRole: String?
    var thumbNailPicture, picture: String?
    let workPhoneNumber: String?
    let address: String?
    let emailID: String?
    let isChatAvailable: Bool?
    let jabberID: String?
    let roleID: Int64?
    let employeeCompanyID: Int64?
    let employeeCompanyName: String?
    let employeeDepartmentID: Int64?
    let employeeDepartmentName: String?
    let employeeLocationID: Int64?
    let employeeLocationName: String?
    let employeeEmploymentTypeId: Int64?
    let employeeEmploymentTypeName: String?
    let isAllowSick,isShowPlanner: Bool?
    let isShowLogBook, isShowPersonalInfo, isShowDoccument, isTeamMember, isProxyMember, isShowContact, isShowBankInfo, isShowProfile: Bool?
    var isSelected : Bool?
    let isAtWork: Bool?
    let employeeFirebaseId: String?
    let employeeFirebaseUUID : String?
    let loggedInRoleId: Int64?
    let isShowEmpDob, isEmployeeCanUploadPhoto: Bool?
    let uniqueID: String?
    let isProxyShowContact, isProxyShowPersonal, isProxyShowBankDetail, isShowEmailMatchingAdminDomain: Bool?
    let isShowEmpStatistics: Bool?
    let nationality: String?
    let nationalityID: Int?
    
    enum CodingKeys: String, CodingKey {
        case employeeID = "EmployeeId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case knownAs = "KnownAs"
        case jobRole = "JobRole"
        case thumbNailPicture = "ThumbNailPicture"
        case picture = "Picture"
        case workPhoneNumber = "WorkPhoneNumber"
        case address = "Address"
        case emailID = "EmailId"
        case isChatAvailable = "IsChatAvailable"
        case jabberID = "JabberId"
        case roleID = "RoleId"
        case loggedInRoleId = "LoggedInRoleId"
        case employeeCompanyID = "EmployeeCompanyId"
        case employeeCompanyName = "EmployeeCompanyName"
        case employeeDepartmentID = "EmployeeDepartmentId"
        case employeeDepartmentName = "EmployeeDepartmentName"
        case employeeLocationID = "EmployeeLocationId"
        case employeeLocationName = "EmployeeLocationName"
        case employeeEmploymentTypeId = "EmployeeEmploymentTypeId"
        case employeeEmploymentTypeName = "EmployeeEmploymentTypeName"
        case isAllowSick = "IsAllowSick"
        case isShowPlanner = "IsShowPlanner"
        case isShowLogBook = "IsShowLogBook"
        case isShowPersonalInfo = "IsShowPersonalInfo"
        case isShowDoccument = "IsShowDoccument"
        case isSelected = "isSelected"
        case isAtWork = "IsAtWork"
        case employeeFirebaseId = "FirebaseID"
        case employeeFirebaseUUID = "FirebaseUUID"
        case isTeamMember = "IsTeamMember"
        case isProxyMember = "IsProxyMember"
        case isShowContact = "IsShowContact"
        case isShowBankInfo = "IsShowBankInfo"
        case isShowProfile = "IsShowProfile"
        case isShowEmpDob = "IsShowEmpDob"
        case isEmployeeCanUploadPhoto = "IsEmployeeCanUploadPhoto"
        case uniqueID = "UniqueId"
        case isProxyShowContact = "IsProxyShowContact"
        case isProxyShowPersonal = "IsProxyShowPersonal"
        case isProxyShowBankDetail = "IsProxyShowBankDetail"
        case isShowEmailMatchingAdminDomain = "IsShowEmailMatchingAdminDomain"
        case isShowEmpStatistics = "IsShowEmpStatistics"
        case nationalityID = "NationalityId"
        case nationality = "Nationality"
    }
    
    init(employeeID: Int64?, firstName: String?, lastName: String?, knownAs: String?, jobRole: String?, thumbNailPicture: String?, picture: String?, workPhoneNumber: String?, address: String?, emailID: String?, isChatAvailable: Bool?, jabberID: String?, roleID: Int64?, employeeCompanyID: Int64?, employeeCompanyName: String?, employeeDepartmentID: Int64?, employeeDepartmentName: String?, employeeLocationID: Int64?, employeeLocationName: String?, employeeEmploymentTypeId: Int64?, employeeEmploymentTypeName: String?, isSelected: Bool?, isAtWork: Bool?,isAllowSick: Bool?, isShowPlanner: Bool?, isShowLogBook: Bool?, isShowPersonalInfo: Bool?, isShowDoccument: Bool?, employeeFirebaseId: String?,employeeFirebaseUUID:String?, isTeamMember: Bool?, isProxyMember: Bool?, isShowContact: Bool?, isShowBankInfo: Bool?, isShowProfile: Bool?, loggedInRoleId: Int64?, isShowEmpDob: Bool?, isEmployeeCanUploadPhoto: Bool?, uniqueID: String?, isProxyShowContact: Bool?, isProxyShowPersonal: Bool?, isProxyShowBankDetail: Bool?, isShowEmailMatchingAdminDomain: Bool?, isShowEmpStatistics: Bool?, nationality: String?, nationalityID: Int?) {
        
        self.employeeID = employeeID
        self.firstName = firstName
        self.lastName = lastName
        self.knownAs = knownAs
        self.jobRole = jobRole
        self.thumbNailPicture = thumbNailPicture
        self.picture = picture
        self.workPhoneNumber = workPhoneNumber
        self.address = address
        self.emailID = emailID
        self.isChatAvailable = isChatAvailable
        self.jabberID = jabberID
        self.roleID = roleID
        self.employeeCompanyID = employeeCompanyID
        self.employeeCompanyName = employeeCompanyName
        self.employeeDepartmentID = employeeDepartmentID
        self.employeeDepartmentName = employeeDepartmentName
        self.employeeLocationID = employeeLocationID
        self.employeeLocationName = employeeLocationName
        self.employeeEmploymentTypeId = employeeEmploymentTypeId
        self.employeeEmploymentTypeName = employeeEmploymentTypeName
        self.isSelected = isSelected
        self.isAllowSick = isAllowSick
        self.isAtWork = isAtWork
        self.isShowPlanner = isShowPlanner
        self.isShowLogBook = isShowLogBook
        self.isShowPersonalInfo = isShowPersonalInfo
        self.isShowDoccument = isShowDoccument
        self.employeeFirebaseId = employeeFirebaseId
        self.employeeFirebaseUUID = employeeFirebaseUUID
        self.isTeamMember = isTeamMember
        self.isProxyMember = isProxyMember
        self.isShowContact = isShowContact
        self.isShowBankInfo = isShowBankInfo
        self.isShowProfile = isShowProfile
        self.loggedInRoleId = loggedInRoleId
        self.isShowEmpDob = isShowEmpDob
        self.isEmployeeCanUploadPhoto = isEmployeeCanUploadPhoto
        self.uniqueID = uniqueID
        self.isProxyShowContact = isProxyShowContact
        self.isProxyShowPersonal = isProxyShowPersonal
        self.isProxyShowBankDetail = isProxyShowBankDetail
        self.isShowEmailMatchingAdminDomain = isShowEmailMatchingAdminDomain
        self.isShowEmpStatistics = isShowEmpStatistics
        self.nationalityID = nationalityID
        self.nationality = nationality
    }
}



