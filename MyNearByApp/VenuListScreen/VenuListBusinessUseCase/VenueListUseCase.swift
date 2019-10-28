//
//  GetNearByPlacesUseCase.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
struct DefaultPlace {
    static let lat: Float = 29.962696
    static let lon: Float = 31.276941
}
 struct Place {
    var latitude: Float
    var longitude: Float
    var localizedDescription: String {
        return "\(latitude),\(longitude)"
    }
}
protocol UseCase {
    //var request: RequestProtocol? {get}
}

struct VenusRequestKeys {
   static let latLongKey = "ll"
   static let intentKey = "intent"
}

class VenueListUseCase: UseCase {
  
    var currentPlace : Place = Place(latitude:DefaultPlace.lat, longitude: DefaultPlace.lon )
    var searchRadius : Int = 1000
    var venuListRepo : VenuListDataRepositoryProtocol?
    
    func setPlace(place: Place, searchRadius: Int){
        self.currentPlace = place
        self.searchRadius = searchRadius
    }
    init(venuListRepo: VenuListDataRepositoryProtocol? = VenuListDataRepository()) {
        self.venuListRepo = venuListRepo
    }
    func fetcNearByVenues(completion: @escaping NetworkCompletion) {
        venuListRepo?.fetcNearByVenues(around: currentPlace, with: searchRadius, completion: completion)
    }
    
    // TODO : get user current saved location
    
    
}
