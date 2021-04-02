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
    let gender: String?
    let location: Location?
    let email: String?
    let login: Login?
    let cell: String?
    let dob: DateData?
    let registered: DateData?
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct Location: Codable {
    let city: String?
    let state: String?
    let country: String?
    let street: Street?
    let timezone: Timezone?
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

struct Picture: Codable {
    let thumbnail: String?
}

struct Login: Codable {
    let username: String?
}

struct DateData: Codable {
    let date: String?
    let age: Int?
}

struct Timezone: Codable {
    let offset: String?
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

extension User {
    var genderWithAge: String? {
        guard let gender = self.gender,
              let age = self.dob?.age else {
            return nil
        }
        return gender.capitalized + ", \(age)"
    }
    
    var addressString: String? {
        guard let streetName = self.location?.street?.name,
              let number = self.location?.street?.number else {
            return nil
        }
        
        return "\(number) " + streetName
    }
    
    var countryString: String? {
        guard let city = self.location?.city,
              let state = self.location?.state,
              let country = self.location?.country else {
            return nil
        }
        
        return city + ", " + state + ", " + country
    }
    
    var birdthday: String? {
        guard var dateString = self.dob?.date else {
            return nil
        }
        
        dateString.removeLast(5)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = dateFormatter.date(from:dateString)!
        
        dateFormatter.dateFormat = "d'th' MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    var registration: String? {
        guard var dateString = self.registered?.date else {
            return nil
        }
        
        dateString.removeLast(5)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let date = dateFormatter.date(from:dateString)!
        
        dateFormatter.dateFormat = "d'th' MMMM yyyy',' HH:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        return dateFormatter.string(from: date)
    }
    
    var timezone: String? {
        guard let time = self.location?.timezone?.offset,
              let offset = time.split(separator: ":").first else {
            return nil
        }
        
        return "(GMT\(offset))"
    }
}

