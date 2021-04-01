//
//  User.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import Foundation
import UIKit

struct Users: Codable {
    let results: [User]?
}

struct User: Codable {
    let name: Name?
    var image: UIImage?
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct Location: Codable {
    
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

extension Name {
    var fullName: String? {
        guard let firstName = first,
              let lastName = last else {
            return nil
        }
        
        return firstName + " " + lastName
    }
}
