//
//  RepositoryTests.swift
//  MyNearByAppTests
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation

import XCTest
@testable import MyNearByApp

class VenuDataRepositoryTests: XCTestCase {
    
    var venueListDataRepository: VenuListDataRepositoryProtocol?
    var mockDataSource: VenuListDataSource!
    override func setUp() {
        super.setUp()
        mockDataSource = MockDataSource()
        venueListDataRepository =  VenuListDataRepository(remoteDataSource: mockDataSource, localDataSource: mockDataSource)
        
    }
    override func tearDown() {
        venueListDataRepository = nil
        mockDataSource = nil
        super.tearDown()
    }
    func testfetchVenue(){
        let place = Place(latitude:DefaultPlace.lat, longitude: DefaultPlace.lon)
        venueListDataRepository?.fetcNearByVenues(around: place, with: 500, completion:{ (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        })
    }
    
}
class MockDataSource: VenuListDataSource{
    var networkManager: NetworkManagerProtocol?
    
    var localDataManager: LocaleDataManagerProtocol?
    
    func fetcNearByVenues(around place: Place, with radius: Int, completion: @escaping NetworkCompletion) {
        completion("fetched", nil)
    }
    
    
}
