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
enum ToastPosition {
    case top
    case middle
    case bottom
}

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
    
    func attributedTextWithBlackUnderLine(url: String, color: UIColor) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self,
                                                         attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto", size: 17.0)!])
        let blackUnderLineAtt: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: "Roboto", size: 17.0),
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.underlineStyle : 1]
        let range = (self as NSString).range(of: url, options: .caseInsensitive)
        attributedString.addAttributes(blackUnderLineAtt, range: range)
        return attributedString
    }

}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
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

//MARK:- UIViewController
extension UIViewController {
    func showToast(message : String , toastPosition: ToastPosition = .middle) {
        
        if let toast = self.view.viewWithTag(101){
            toast.removeFromSuperview()
        }
        
        let tempLabel = UILabel()
        tempLabel.numberOfLines = 0
        tempLabel.frame.origin.x = 16
        tempLabel.frame.size.width = self.view.frame.size.width - 32
        tempLabel.font = UIFont(name:"Roboto", size: 17)
        tempLabel.text = message
        tempLabel.clipsToBounds = true
        tempLabel.sizeToFit()
        
        
        
        
        
        if let toast = self.view.viewWithTag(101){
            toast.removeFromSuperview()
        }
        
        let toastLabel = PaddingLabel()
        toastLabel.tag = 101
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Roboto", size: 17)
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        //toastLabel.sizeToFit()
        if let v = UIApplication.shared.keyWindow{
            v.addSubview(toastLabel)
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 16).isActive = true
            toastLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -16).isActive = true
            // set position fot toast
            if toastPosition == .middle{
                toastLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: -20).isActive = true
            }else if toastPosition == .top{
                toastLabel.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            }else{
                    toastLabel.centerYAnchor.constraint(equalTo: v.safeAreaLayoutGuide.bottomAnchor, constant: -155).isActive = true
            }
            toastLabel.heightAnchor.constraint(equalToConstant: tempLabel.bounds.height + 20).isActive = true
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1
        }, completion: {(isCompleted) in
            
            UIView.animate(withDuration: 0.2, delay: 2, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        })
        
    }

}

//MARK:- UIView
extension UIView {
    func addLoaderInView(){
        ActivityIndicator.addActivityIndicator(view: self)
    }
    
    func showLoader(){
        ActivityIndicator.viewLoader.isHidden = false
        ActivityIndicator.viewLoader.startAnimating()
    }
    
    func removeLoader(){
        ActivityIndicator.viewLoader.isHidden = true
        ActivityIndicator.viewLoader.stopAnimating()
    }
    
    private struct ActivityIndicator{
        static let viewLoader: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = UIColor(hexString: "313E5A")
            activityIndicator.isHidden = true
            return activityIndicator
        }()
        
        static func addActivityIndicator(view: UIView){
            ActivityIndicator.viewLoader.removeFromSuperview()
            view.addSubview(ActivityIndicator.viewLoader)
            ActivityIndicator.viewLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            ActivityIndicator.viewLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            ActivityIndicator.viewLoader.widthAnchor.constraint(equalToConstant: 16).isActive = true
            ActivityIndicator.viewLoader.heightAnchor.constraint(equalToConstant: 16).isActive = true
        }
    }
}
