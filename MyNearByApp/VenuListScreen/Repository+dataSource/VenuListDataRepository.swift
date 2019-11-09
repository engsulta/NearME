//
//  VenuListDataRepository.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation


//// repository Type protocol that can be injected to use case
protocol VenuListDataRepositoryProtocol {
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion)
    func fetcVenuePhoto(withId venueId: String, completion: @escaping NetworkCompletion)
}

/// concrete implementation to repository
class VenuListDataRepository: VenuListDataRepositoryProtocol {
    func fetcVenuePhoto(withId venueId: String, completion: @escaping NetworkCompletion) {
        remoteDataSource.fetcVenuePhoto(withId: venueId, completion: completion)
    }
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion) {
        remoteDataSource.fetcNearByVenues(around: place, with: radius, completion: completion)
        //here we can save the response into local data store each time we fetch from remote
        //then we can check network error code if not success we can load from local store if exist
    }
    
    private let remoteDataSource: VenuListDataSource
    private let localDataSource: VenuListDataSource?
    
    init(remoteDataSource: VenuListDataSource = VenuListRemoteDataSource(), localDataSource: VenuListDataSource? = nil) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
}


/// data source type to be injected to repository
protocol VenuListDataSource {
    var networkManager: NetworkManagerProtocol? {get set}
    var localDataManager: LocaleDataManagerProtocol? {get set}
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion)
    func fetcVenuePhoto(withId venueId: String, completion: @escaping NetworkCompletion)
}

/// remote Data source
struct VenuListRemoteDataSource: VenuListDataSource {
    var localDataManager: LocaleDataManagerProtocol?
    
    var networkManager: NetworkManagerProtocol?
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion){
       let request = NearByRequest(path: EndPoint.search.rawValue,
                      httpMethode: .get,
                      parameters: [VenusRequestKeys.latLongKey: place.localizedDescription,
                                   VenusRequestKeys.intentKey: Intent.checkin.rawValue,
                                   "radius": radius])
        networkManager?.execute(request: request, model: VenueResponse.self, completion: completion)
    }
    func fetcVenuePhoto(withId venueId: String, completion: @escaping NetworkCompletion) {
        let venueIdPath = EndPoint.venuePhoto.rawValue.replacingOccurrences(of: "{VENUE_ID}", with: "\(venueId)")
        let request = NearByRequest(path: venueIdPath,
                             httpMethode: .get)
        networkManager?.execute(request: request, model: VenueResponse.self, completion: completion)
    }
}


/// local Data Source
struct VenuListLocalDataSource: VenuListDataSource {
    var networkManager: NetworkManagerProtocol?
    
    var localDataManager: LocaleDataManagerProtocol?
    init(localDataManager: LocaleDataManagerProtocol) {
        self.localDataManager = localDataManager
    }
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion){
        // for future optimization this will load from local data base eg. realm or core data
    }
    func fetcVenuePhoto(withId venueId: String, completion: @escaping NetworkCompletion) {
        //for future optimization this will load from local data base eg. realm or core data
    }
}

protocol LocaleDataManagerProtocol {
}

/// default data source
extension VenuListDataSource{
    // var networkManager: NetworkManagerProtocol? { get { return nil } set{} }
    //var localDataManager: LocaleDataManagerProtocol? {get { return nil} set {}}
}

enum EndPoint: String {
    case search = "/v2/venues/search"
    case categories = "/v2/venues/categories"
    case venuePhoto = "/v2/venues/{VENUE_ID}/photos"
}

enum Intent: String{
    case checkin = "checkin"
    case browse = "browse"
}
