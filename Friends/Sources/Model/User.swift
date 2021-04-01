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
    var image: Image?
    let picture: Picture?
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

struct Picture: Codable {
    let thumbnail: String?
}

// Workaround for UIImage codable
struct Image: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}

extension String {
    var url: URL? {
        return URL(string: self)
    }
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
