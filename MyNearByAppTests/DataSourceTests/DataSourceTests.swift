//
//  DataSourceTests.swift
//  MyNearByAppTests
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import XCTest
@testable import MyNearByApp

class RemoteVenuDataSourceTests: XCTestCase {
    
    var venueListDataSource: VenuListDataSource?
    var networkManager: NetworkManagerProtocol!
    var mockRequest: RequestProtocol!

    override func setUp() {
        super.setUp()
        let mockSession = URLSessionMock()
        mockRequest = NearByRequest(path: "www.test.com", httpMethode: .get,
                                    headers: ["test": "test"],
                                    cachePolicy: .reloadIgnoringLocalCacheData)
        networkManager = NetworkManager(baseURL: "any", session: mockSession)
        venueListDataSource =  VenuListRemoteDataSource(networkManager: networkManager)
        
        
    }
    override func tearDown() {
        venueListDataSource = nil
        networkManager = nil
        super.tearDown()
    }
    func testfetchVenue(){
        let place = Place(latitude:DefaultPlace.lat, longitude: DefaultPlace.lon)
       
    }
    
}
