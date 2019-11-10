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
    var image: UIImage?
    init(with venueId: String, venueUseCase: VenueListUseCase?, completion: @escaping (UIImage?)->Void ){
        self.venueId = venueId
        // create asynch fetch url operaiton
        let asynchFetchOperation = VenuePhotoFetchOperation(inputVenueId: venueId, venueUseCase: venueUseCase)
         // create image download call to get the image itself
        let downloadImageOperation = ImageDownloadOperation(inputImageUrl: nil,completion: completion)
          // link all dependencies
        downloadImageOperation.addDependency(asynchFetchOperation)
        // start operations
        queue.addOperation(asynchFetchOperation)
        queue.addOperation(downloadImageOperation)
        // listen to output
        downloadImageOperation.completionBlock = {
            self.image = downloadImageOperation.outputImage
            print("Image Downloaded successfully")
        }
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
        
        if let imageinupt = filterInputImageUrl {
            // start image download operation
            // todo: use your network layer instead of sd web image pod
            SDWebImageManager.shared.loadImage(with: URL(string: imageinupt), progress: nil) { (uiImage, _, _, _, _, _) in
                if let image = uiImage {
                    self.outputImage = image
                    self.completion?(image)
                    self.state = .finished
                }
            }
        }else {
            // todo: handle no url for this image
            self.outputImage = UIImage(named: "noImage")
            self.completion?(self.outputImage)
            self.state = .finished
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
        
        venueUseCase?.fetcVenuePhoto(withId: venueId) { (responseModel, error) in
            guard !self.isCancelled else {return}
            guard error == nil, let veneuePhotoResponse = responseModel as? VenuePhotoResponse else {
                self.outputImageURL = nil
                self.completion?(nil)
                self.state = .finished
                
                return
            }
            let prefix = (veneuePhotoResponse.response?.photos?.items?.first?.prefix) ?? ""
            let suffix = (veneuePhotoResponse.response?.photos?.items?.first?.suffix) ?? ""
            let width = veneuePhotoResponse.response?.photos?.items?.first?.width ?? 0
            let height = veneuePhotoResponse.response?.photos?.items?.first?.height ?? 0
            self.outputImageURL = "\(prefix)\(width)x\(height)\(suffix)"
            self.completion?(self.outputImageURL ?? "")
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
