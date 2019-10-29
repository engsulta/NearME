//
//  UseCaseTests.swift
//  MyNearByAppTests
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import XCTest
@testable import MyNearByApp

class VenuUseCaseTests: XCTestCase {
    
    var venueListUseCase: VenueListUseCase?
    var mockReop: VenuListDataRepositoryProtocol?
    override func setUp() {
        super.setUp()
        mockReop = MockReop()
        venueListUseCase =  VenueListUseCase(venuListRepo: mockReop)
        
    }
    override func tearDown() {
        venueListUseCase = nil
        mockReop = nil
        super.tearDown()
    }
    func testfetchVenue(){
        let place = Place(latitude:DefaultPlace.lat, longitude: DefaultPlace.lon)
        venueListUseCase?.setPlace(place: place , searchRadius: 500)
        venueListUseCase?.fetcNearByVenues(completion: { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        })
    }
}

class MockReop: VenuListDataRepositoryProtocol{
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion) {
        completion("fetched", nil)
    }
    
    
}
