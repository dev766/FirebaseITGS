//
//  Generic.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import Foundation


// MARK:- Extensions
extension String {
    func dateFromMilliseconds(format:String) -> Date? {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self)! / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date as Date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return (formatter.date(from: timeStamp))
    }
    
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


