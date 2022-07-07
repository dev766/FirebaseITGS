//
//  UIViewExtension.swift
//  PeopleHr
//
//  Created by iT Gurus Software on 12/26/18.
//  Copyright © 2018 iT Gurus Software. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    
    // access constaints
    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var leadingConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                ($0.firstAttribute == .leading || $0.firstAttribute == .leadingMargin) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var trailingConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                ($0.firstAttribute == .trailing || $0.firstAttribute == .trailingMargin) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var topConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                ($0.firstAttribute == .top || $0.firstAttribute == .topMargin) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var bottomConstaint: NSLayoutConstraint? {
        get {
            return superview?.constraints.first(where: {
                ($0.firstAttribute == .bottom && ($0.secondItem as? UIView) == self) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var centerXConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                ($0.firstAttribute == .centerX || $0.firstAttribute == .centerXWithinMargins) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var centeryConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                ($0.firstAttribute == .centerY || $0.firstAttribute == .centerYWithinMargins) && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    // ---------------
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
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
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    // OUTPUT 1
       func dropShadow(scale: Bool = true) {
           layer.masksToBounds = false
           layer.shadowColor = UIColor.black.cgColor
           layer.shadowOpacity = 0.5
           layer.shadowOffset = CGSize(width: -1, height: 1)
           layer.shadowRadius = 1
           
           layer.shadowPath = UIBezierPath(rect: bounds).cgPath
           layer.shouldRasterize = true
           layer.rasterizationScale = scale ? UIScreen.main.scale : 1
       }
       
       // OUTPUT 2
       func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
           layer.masksToBounds = false
           layer.shadowColor = color.cgColor
           layer.shadowOpacity = opacity
           layer.shadowOffset = offSet
           layer.shadowRadius = radius
           
           layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
           layer.shouldRasterize = true
           layer.rasterizationScale = scale ? UIScreen.main.scale : 1
       }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func pushTransition(_ duration:CFTimeInterval, animatesToTop:Bool) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        if animatesToTop{
            animation.subtype = CATransitionSubtype.fromTop
        }else{
            animation.subtype = CATransitionSubtype.fromBottom
        }
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func calculateLabelLines() -> Int {
        let maxSize = CGSize(width: UIScreen.main.bounds.width - 32, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func addCharacterSpacing(kernValue: Double = 0.5) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}

extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
}

