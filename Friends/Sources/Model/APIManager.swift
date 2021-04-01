//
//  APIManager.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import Foundation

class APIManager {
}

extension APIManager {
    static func makeRequest(_ params: [String: String], completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "https://randomuser.me/api/"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        let queryItems: [URLQueryItem] = params.map { parameter in
            URLQueryItem(name: parameter.key, value: parameter.value)
        }
        

        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)


        request.httpMethod = "GET"

        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                // Handle unexpected error
            }
        }
        
        task.resume()
    }
}
