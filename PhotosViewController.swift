//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Zack Falgout on 5/18/17.
//  Copyright © 2017 Zack Falgout. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate{
    
    //@IBOutlet var imageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            /*
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                //if let firstPhoto = photos.first{
                //    self.updateImageView(for: firstPhoto)
                //}
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            */
            
            self.updateDataSource()
        }
    }
    
//    func updateImageView(for photo: Photo){
//        store.fetchImage(for: photo) {
//            (imageResult) -> Void in
//
//            switch imageResult {
//
//            case let .success(image):
//                self.imageView.image = image
//
//            case let .failure(error):
//                print("Error downloading image: \(error)")
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        let photo = photoDataSource.photos[indexPath.row]
        
        //Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in
            
            //The indec path for the photo might have changed between the time the request started and finished, so find the most recent index path.
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            //When the request finished, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell{
                cell.update(with: image)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue Identifier")
        }
    }
    
    private func updateDataSource() {
        store.fetchAllPhotos {
            (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}
