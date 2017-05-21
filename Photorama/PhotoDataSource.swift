//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Zack Falgout on 5/19/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource{
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "PhotoCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.photoDescription = photo.title
        
        return cell
    }
    
    //Chapter 24 code
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits | UIAccessibilityTraitImage
        }
        set {
            //Ignore attempts to set
        }
    }
}
