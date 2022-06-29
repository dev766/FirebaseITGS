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

