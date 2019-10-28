//
//  NetworkLoggerTests.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import XCTest
@testable import MyNearByApp

class NetworkLoggerTests: XCTestCase {

    let session = URLSessionMock()
    var mockClient: NetworkManager!
    var mockRequest: RequestProtocol!

    override func setUp() {
        super.setUp()
        mockClient = NetworkManager(baseURL: "www.test.com", session: session)
        mockRequest = NearByRequest(path: "www.test.com", httpMethode: .get,
                                    headers: ["test": "test"],
                                    cachePolicy: .reloadIgnoringLocalCacheData)
    }

    func testLogRequest( ) {
        let url = URL(string: "www.test.com")
        guard let request = (try? mockClient.buildRequest(from: mockRequest, with: [:], to: url)) else {
            XCTFail("fail to create request")
            return
        }
        NetworkLogger.log(request: request)
    }

    func testLogResponse( ) {
        guard let url = URL(string: "www.test.com") else {
            XCTFail("fail to create url")
            return
        }
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            XCTFail("fail to create response")
            return
        }
        NetworkLogger.log(response: response)
    }

    override func tearDown() {
        mockClient = nil
        mockRequest = nil
        super.tearDown()
    }
}
