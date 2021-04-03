//
//  UsersModel.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import Foundation
import UIKit

class UsersModel {
    static let shared = UsersModel()
    
    var manager = APIManager()
    var users = [User]()
    
    func getUsers(count: Int = 5, completion: @escaping (Result<[User], Error>) -> ()) {
        let params: [String:String] = ["results" : "\(count)"]
        
        manager.makeRequest(params) { (result) in
            switch result {
            case let .success(value):
                do {
                    let results = try JSONDecoder().decode(Users.self, from: value)
                    self.users = results.results ?? []
                    
                    completion(.success(self.users))
                }
                catch {
                    print("JSONSerialization error:", error)
                    completion(.failure(error))
                }
                
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func getUserImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> ()) {
        manager.downloadImage(with: url) { result in
            
            if case let .success(image) = result {
                if let index = self.users.firstIndex(where: {
                    $0.picture?.medium?.url == url
                }) {
                    self.users[index].image = Image(withImage: image)
                }
            }
            
            completion(result)
            
        }
    }
}
