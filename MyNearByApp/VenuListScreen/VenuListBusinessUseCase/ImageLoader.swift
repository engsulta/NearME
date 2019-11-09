//
//  ImageLoader.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/9/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ImageLoader {
    var queue = OperationQueue()
    var venueId: String
    init(with venueId: String, venueUseCase: VenueListUseCase?, completion: @escaping (UIImage?)->Void ){
        self.venueId = venueId
        // create asynch fetch url operaiton
        let asynchFetchOperation = VenuePhotoFetchOperation(inputVenueId: venueId, venueUseCase: venueUseCase)
         // create image download call to get the image itself
        let downloadImageOperation = ImageDownloadOperation(inputImageUrl: nil)
          // link all dependencies
        downloadImageOperation.addDependency(asynchFetchOperation)
        // start operations
        queue.addOperation(asynchFetchOperation)
        queue.addOperation(downloadImageOperation)
    }
    func cancel(){
          queue.cancelAllOperations()
      }
}

extension ImageLoader:  Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(venueId)
    }
    var hashValue: Int {
        return ((venueId ).hashValue)
    }
    static func ==(lhs: ImageLoader, rhs: ImageLoader) -> Bool {
        return lhs.venueId == rhs.venueId
    }
}



class ImageDownloadOperation: AsynchOperation {
    fileprivate var inputImageUrl : String?
    var completion : ((UIImage?) -> Void)?
    var outputImage : UIImage?
    // this how can you get the input image url for this operation
    var filterInputImageUrl: String? {
           var imageURL: String?
           if let inputImage = inputImageUrl {
               imageURL = inputImage
           } else if let dataProvider = dependencies
            .filter({ $0 is PhotoURLOperationDataProvider })
            .first as? PhotoURLOperationDataProvider {
               imageURL = dataProvider.photoURL
           }
           return imageURL
       }
    init(inputImageUrl : String? , completion:  ((UIImage?) -> Void)? = nil) {
        self.inputImageUrl = inputImageUrl
        self.completion = completion
        super.init()
    }
    
    override func main() {
        guard !isCancelled else {return}
        
        if let imageinupt = inputImageUrl {
            // start image download operation
        }
    }
}

class VenuePhotoFetchOperation: AsynchOperation {
  
    fileprivate var venueUseCase: VenueListUseCase?
    fileprivate var venueId : String
    var completion : ((String?) -> Void)?
    var outputImageURL : String?
    
    init(inputVenueId venueId : String, venueUseCase: VenueListUseCase?,completion:  ((String?) -> Void)? = nil) {
        
        self.venueUseCase = venueUseCase
        self.venueId = venueId
        self.completion = completion
        super.init()
        
    }
    
    override func main() {
        guard !isCancelled else {return}
        
        venueUseCase?.fetcVenuePhoto { (responseModel, error) in
            guard !self.isCancelled else {return}
            guard error == nil, let veneuePhotoResponse = responseModel as? VenuePhotoResponse else {return}
            let prefix = String(describing: veneuePhotoResponse.response?.photos?.items?.first?.prefix)
            let suffix = String(describing: veneuePhotoResponse.response?.photos?.items?.first?.suffix)
            self.outputImageURL = "\(prefix)500x500\(suffix)"
            self.completion?(self.outputImageURL)
            self.state = .finished
        }
    }
}

extension VenuePhotoFetchOperation: PhotoURLOperationDataProvider {
    var photoURL: String? {
        return self.outputImageURL
    }
}

protocol PhotoURLOperationDataProvider {
    var photoURL: String? { get}
}
