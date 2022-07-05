//
//  FirebaseServices.swift
//  FirebaseITGS
//
//  Created by Apple on 28/06/22.
//

import Foundation
import UIKit
import InitialsImageView

//MARK:- STRING

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
    
    func getFullName(lastName:[String])-> String{
        var userName = ""
        let userFirstName = self
        let userLastNameArray = lastName
        if let userLastName = userLastNameArray.first {
            userName = userFirstName + " " + userLastName
        }
        return userName
    }
    
    func getChatuserName() -> String{
        let nameArr = self.components(separatedBy: ",")
        let firstName = "Akash"//(UserDefaults.standard.value(forKey: "FirstName") as? [String])!
        let lastname = ["patil"]//(UserDefaults.standard.value(forKey: "LastName") as? [String]) ?? [""]
        let userFullName =  firstName.getFullName(lastName:lastname)
        let newChatUserName:NSMutableArray = []
        for name in nameArr {
            if name != userFullName{
                newChatUserName.add(name)
            }
        }
        let chatTitleName = newChatUserName.componentsJoined(by: ",")
        return chatTitleName
    }
    
    func attributedTextForColor(colorString: String, attributedColor:UIColor) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 17.0)!])
        let colorAttribute: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.foregroundColor: attributedColor]
        let range = (self as NSString).range(of: colorString, options: .caseInsensitive)
        attributedString.addAttributes(colorAttribute, range: range)
        return attributedString
    }

}

//MARK:- UIColor Extensions
extension UIColor {
    convenience init(hexString: String) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        
    }

    convenience init(hexString: String, alpha: CGFloat) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
        
    }

}

//MARK:- UIImageView

extension UIImageView {

func setImage(link:String, imageType : imageType, showLoadingIndicator: Bool = false, displayAnimation:Bool = false, userName: String? = nil) {
    
    let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
    loadingIndicator.tag = 99
    loadingIndicator.frame = CGRect(x: self.bounds.midX - 25, y: self.bounds.midY - 25, width: 50, height: 50)
    if showLoadingIndicator{
        
        self.addSubview(loadingIndicator)
        loadingIndicator.center = self.convert(self.center, from: self.superview)
        loadingIndicator.layoutIfNeeded()
        loadingIndicator.startAnimating()
    }
    
    
        switch imageType {
        case .BadgeImage :
            self.image = UIImage(named: "Default-User")
        case .UserImage :
            if userName != nil{
                self.setImageForName(userName!, backgroundColor: nil, circular: true, textAttributes: nil, gradient: false)
                
            }else{
                self.image = UIImage(named: "Default-User")
            }
        case .noImage:
            self.image = UIImage(named: "Default-User")
        default:
            print("")
        }
}
}
