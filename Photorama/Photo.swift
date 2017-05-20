//
//  Photo.swift
//  Photorama
//
//  Created by Zack Falgout on 5/18/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import Foundation

class Photo{
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date){
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
    /*static func == (lhs: Photo, rhs: Photo) -> Bool {
        //Two Photos are the same if the have the same photoId
        return lhs.photoID == rhs.photoID
    }*/
    
}

extension Photo: Equatable{
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        //Two Photos are the same if the have the same photoId
        return lhs.photoID == rhs.photoID
    }
}
