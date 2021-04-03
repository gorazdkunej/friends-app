//
//  UIColor.swift
//  Friends
//
//  Created by Gorazd Kunej on 03/04/2021.
//

import UIKit

extension UIColor {
    public enum skratch { }
}

extension UIColor.skratch {
    static var navy: UIColor {
        guard let color = UIColor(named: "navy") else {
            return .black
        }
        return color
    }
    static var navy50: UIColor {
        guard let color = UIColor(named: "Navy50%") else {
            return .darkGray
        }
        return color
    }
    
    static var paleBlue: UIColor {
        guard let color = UIColor(named: "PaleBlue") else {
            return .blue
        }
        return color
    }
    
    static var purple: UIColor {
        guard let color = UIColor(named: "Purple") else {
            return .purple
        }
        return color
    }
    
    static var text: UIColor {
        guard let navy = UIColor(named: "Text") else {
            return .darkGray
        }
        return navy
    }
}
