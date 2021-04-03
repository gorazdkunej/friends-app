//
//  String.swift
//  Friends
//
//  Created by Gorazd Kunej on 02/04/2021.
//

import UIKit
import Foundation

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension BidirectionalCollection where Iterator.Element == String {
    var sentence: String {
        guard let last = last else { return "" }
        return count <= 2 ? joined(separator:" and ") :
            dropLast().joined(separator: ", ") + " and " + last
    }
}
