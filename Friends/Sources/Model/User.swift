//
//  User.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import Foundation

struct Users: Codable {
    let results: [User]?
}

struct User: Codable {
    let name: Name?
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
