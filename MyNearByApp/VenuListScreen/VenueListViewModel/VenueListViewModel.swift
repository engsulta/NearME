//
//  VenuListViewModel.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var messageTxt: String
    var messageImage: UIImage
    init(error: NetworkRequestError) {
        switch error {
        case .noInternetConnection:
            self.messageTxt = ""
            self.messageImage = UIImage()
        default:
            self.messageTxt = ""
            self.messageImage = UIImage()
        }
    }
}
class VenueListViewModel {
    /// use case will handle any business logic
    let venueUseCase: VenueListUseCase?
    
    /// data model initialization
    private var venues: [Venue] = [Venue]()
    
    /// inside the list View model we have an array of cell View models
    private var cellViewModels: [VenueListCellViewModel] = [VenueListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
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
    
    var reloadTableViewClosure: (()->())?
    var showWarningClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(venueUseCase: VenueListUseCase = VenueListUseCase()) {
        self.venueUseCase = venueUseCase
    }
    
    func initFetch() {
        self.isLoading = true
        ///ask use case to get user save location
        // get location and setup notification to refetch with region
        /// ask use case to fetch places
        venueUseCase?.setPlace(place: Place(latitude: DefaultPlace.lat, longitude: DefaultPlace.lon), searchRadius: 1000)
        venueUseCase?.fetcNearByVenues(completion: {[weak self] (venues, error) in
            // stop loading
            self?.isLoading = false
            // check error and if there is error set warning message View
            if let error = error {
                self?.warningMessage = Message(error: error as! NetworkRequestError)
            } else {
                //  if there are venues process fetched venues
                // catch Venue from response venue
                self?.processFetchedVenue(venues: venues as! [Venue])
            }
        })
    }
    /// will be used by table view to inject in each cell the vm for it
    func getCellViewModel( at indexPath: IndexPath ) -> VenueListCellViewModel {
        return cellViewModels[indexPath.row]
    }

    /// mapping venue to venue Cell VM
    func createCellViewModel( venue: Venue ) -> VenueListCellViewModel {
        
        //Wrap a description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return VenueListCellViewModel( titleText: venue.name ?? "",
                                       descText: venue.location?.state ?? "",
                                       imageUrl: "",
                                       dateText: "" )
    }
    
    private func processFetchedVenue( venues: [Venue] ) {
        self.venues = venues // Cache
        var vms = [VenueListCellViewModel]()
        for venue in venues {
            vms.append( createCellViewModel(venue: venue) )
        }
        self.cellViewModels = vms
    }
}

struct VenueListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
