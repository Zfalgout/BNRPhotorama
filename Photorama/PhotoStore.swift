//
//  PhotoStore.swift
//  Photorama
//
//  Created by Zack Falgout on 5/18/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import UIKit

enum ImageResult{
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error{
    case imageCreationError
}

enum PhotosResult{
    case success([Photo])
    case failure(Error)
}

class PhotoStore{
    
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void){
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
//            if let jsonData = data {
//                //if let jsonString = String(data: jsonData, encoding: .utf8) {
//                //    print(jsonString)
//                //}
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                    print(jsonObject)
//                } catch let error {
//                    print("Error creating JSON object: \(error)")
//                }
//
//            } else if let requestError = error {
//                print("Error fetching interesting photos: \(requestError)")
//            } else {
//                print("Unexpected error with the request")
//            }

            let result = self.procesPhotoRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        
            
        task.resume()
    }
    
    private func procesPhotoRequest(data: Data?, error: Error?) -> PhotosResult{
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void){
        
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey){
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request){
            (data, response, Error) -> Void in
            
            let result = self.processImageRequest(data: data, error: Error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                //Coubn't create an image.
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
}
