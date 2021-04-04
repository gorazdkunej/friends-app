//
//  APIManager.swift
//  Friends
//
//  Created by Gorazd Kunej on 01/04/2021.
//

import Foundation
import UIKit

class APIManager {
    private let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    private let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    
    private var cachedImages = [String: UIImage]()
    private var imagesDownloadTasks = [String: URLSessionDataTask]()
}

extension APIManager {
    func makeRequest(_ params: [String: String], completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: API.url.dev),
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
    
    func downloadImage(with imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        if let image = getCachedImageFrom(urlString: imageUrl.absoluteString) {
            completion(.success(image))
        } else {
            if let _ = getDataTaskFrom(urlString: imageUrl.absoluteString) {
                return
            }
            
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    return
                }
                
                // Store the downloaded image in cache
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[imageUrl.absoluteString] = image
                }
                
                // Clear out the finished task from download tasks container
                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrl.absoluteString)
                }
                
                // Always execute completion handler explicitly on main thread
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
            
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrl.absoluteString] = task
            }
            
            task.resume()
        }
        
    }
    
    private func getCachedImageFrom(urlString: String) -> UIImage? {
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }

    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}
