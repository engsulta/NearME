//
//  VenuListViewModel.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class VenueListViewModel {
    /// use case will handle any business logic
    let venueUseCase: VenueListUseCase?
    var imageLoaderList = Set<ImageLoader>()
    /// data model initialization
    private var venues: [Venue] = [Venue]()
    
    /// inside the list View model we have an array of cell View models
    private var cellViewModels: [VenueListCellViewModel] = [VenueListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    private var detailsViewModels: [VenueDetailsViewModel] = [VenueDetailsViewModel]()
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var warningMessage: Message? {
        didSet {
            self.showWarningClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var locationSwitchStatus: Bool = false {
        didSet{
            switchModeClosure?(locationSwitchStatus)
        }
    }
    var reloadTableViewClosure: (()->())?
    var showWarningClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var switchModeClosure: ((Bool) -> ())?
    
    init(venueUseCase: VenueListUseCase = VenueListUseCase()) {
        self.venueUseCase = venueUseCase
    }
    
    func initFetch(around place: CLLocationCoordinate2D) {
        self.isLoading = true
        ///ask use case to get user save location
        // get location and setup notification to refetch with region
        /// ask use case to fetch places
        venueUseCase?.setPlace(place: Place(latitude: Float(place.latitude), longitude: Float(place.longitude)), searchRadius: 1000)
        venueUseCase?.fetcNearByVenues(completion: {[weak self] (venues, error) in
            // stop loading
            self?.isLoading = false
            // check error and if there is error set warning message View
            if error != nil {
                self?.warningMessage = Message(error: .noInternetConnection)
            } else {
                //  if there are venues process fetched venues
                // catch Venue from response venue
                if let venuesResponse =  venues as? VenueResponse,
                    let venuesModel = venuesResponse.response?.venues, !venuesModel.isEmpty{
                    self?.processFetchedVenue(venues: venuesModel)
                }else{
                    self?.warningMessage = Message(error: .wrongData)
                }
                
            }
        })
    }
    /// will be used by table view to inject in each cell the vm for it
    func getCellViewModel( at indexPath: IndexPath ) -> VenueListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    func display(cell tableCell: VenueListTableViewCell ){
        guard let veneuId = tableCell.venueListCellViewModel?.venueId else { return }
        if let imageLoader = imageLoaderList.first(where: { (imageLoader) -> Bool in
            return imageLoader.venueId == tableCell.venueListCellViewModel?.venueId && imageLoader.image != nil}){
            OperationQueue.main.addOperation {
                tableCell.cellImage = imageLoader.image
            }
        } else {
            let imageLoader = ImageLoader(with: veneuId, venueUseCase: self.venueUseCase) { (image) in
                OperationQueue.main.addOperation {
                    tableCell.cellImage = image
                }
            }
            imageLoaderList.insert(imageLoader)
        }
    }
    func getVenueDetailsVM(at index: IndexPath) -> VenueDetailsViewModel {
        detailsViewModels[index.row]
    }
    func endDisplay(cell tableCell: VenueListTableViewCell){
        if let imageLoader = imageLoaderList.first(where: {(imageLoader) -> Bool in
            return imageLoader.venueId == tableCell.venueListCellViewModel?.venueId
               }){
                   imageLoader.cancel()
                   //imageLoaderList.remove(imageLoader)
               }
    }
    /// mapping venue to venue details VM
    func createDetailsViewModel(venue: Venue) -> VenueDetailsViewModel {
        
        let name = venue.name ?? ""
        let address = venue.location?.address ?? ""
        let city = venue.location?.city ?? ""
        let lat = venue.location?.lat ?? 0
        let long = venue.location?.lng ?? 0
        return VenueDetailsViewModel(name: name,
                                     address: address,
                                     image: nil,
                                     city: city,
                                     lat: lat,
                                     long: long)
        
    }
    /// mapping venue to venue Cell VM
    func createCellViewModel( venue: Venue ) -> VenueListCellViewModel {
        
        //Wrap a description
        let name = venue.name ?? ""
        let address = venue.location?.address ?? ""
        let venueId = venue.id ?? ""
       // let imageURL = "\((venue.categories?.first?.icon?.prefix) ?? "")500x500\((venue.categories?.first?.icon?.suffix) ?? "")"
        return VenueListCellViewModel( titleText: name ,
                                       addressText: address,
                                       imageUrl: "",
                                       venueId: venueId)
    }
    
    private func processFetchedVenue( venues: [Venue] ) {
        self.venues = venues // Cache
        var vms = [VenueListCellViewModel]()
        var detailsVM = [VenueDetailsViewModel]()
        for venue in venues {
            vms.append( createCellViewModel(venue: venue) )
            detailsVM.append ( createDetailsViewModel(venue: venue))
        }
        self.cellViewModels = vms
        self.detailsViewModels = detailsVM
    }
}

extension VenueListViewModel{
    func switchModePressed(status: Bool){
       
    }
}
