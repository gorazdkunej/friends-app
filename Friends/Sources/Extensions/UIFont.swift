//
//  UIFont.swift
//  Friends
//
//  Created by Gorazd Kunej on 04/04/2021.
//

import UIKit

extension UIFont {
    enum skratch { }
}

extension UIFont.skratch {
    
    static func book(size: CGFloat) -> UIFont? {
        return UIFont(name: "CircularStd-Book", size: size)
    }
    
    static func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "CircularStd-Bold", size: size)
    }
    
    static func black(size: CGFloat) -> UIFont? {
        return UIFont(name: "CircularStd-Black", size: size)
    }
    
    static func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "CircularStd-Medium", size: size)
    }
}
