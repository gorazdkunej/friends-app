//
//  UIView.swift
//  Friends
//
//  Created by Gorazd Kunej on 02/04/2021.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                       shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                       shadowOpacity: Float = 0.4,
                       shadowRadius: CGFloat = 3.0) {
            layer.shadowColor = shadowColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
            layer.masksToBounds = false
        }
}
