//
//  VFRequestTypeTests.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import XCTest
@testable import MyNearByApp

class VFGRequestProtocolTests: XCTestCase {

    class MockRequest: RequestProtocol {
        var path: String
        var baseUrl: String
        var httpMethode: HTTPMethod
        var headers: [String: String]?
        var parameters: Parameters

        var isAuthenticationNeededRequest: Bool?
        var cachePolicy: CashPolicy

        init(path: String ,
             baseUrl: String,
             parameters: Parameters = [:],
             httpMethod: HTTPMethod = .get,
             headers: [String: String]? = nil) {

            self.baseUrl = baseUrl
            self.path = path
            self.httpMethode = httpMethod
            self.headers = headers
            self.parameters = parameters

            self.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }
    }

    let session = URLSessionMock()
    var mockClient: NetworkManager!
    var mockNormalRequest: RequestProtocol!
    let testParmaters = ["name": "sulta"]

    override func setUp() {
        super.setUp()
        mockClient = NetworkManager(baseURL: "www.test.com", session: session)
        mockNormalRequest = NearByRequest(path: "www.test.com", httpMethode: .get,
                                       parameters: [:],
                                       headers: ["test": "test"],
                                       cachePolicy: .reloadIgnoringLocalCacheData)
    }

    override func tearDown() {
        mockClient = nil
        mockNormalRequest = nil
        super.tearDown()
    }

    func testRequestWithoutParams() {
        let mockRequest: MockRequest = MockRequest(path: "/demo", baseUrl: "www.test2.com", parameters: ["key":"value"])
        excute(request: mockRequest)
    }


    fileprivate func excute(request: MockRequest) {
        let exp = expectation(description: #function)
        mockClient.execute(request: request, model: MockModel.self) { (model, error) in
            if error != nil {
                XCTAssertNotNil(error as? NetworkRequestError)
            } else {
                 XCTAssertNotNil(model)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testDecodingSuccess() {
        let exp = expectation(description: #function)
        mockClient.execute(request: mockNormalRequest, model: [String].self) { model, error in
            if error != nil {
                XCTFail(error.debugDescription)
            } else {
                XCTAssertNotNil(model)
            }
             exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    func testDecodingFailure() {
        let exp = expectation(description: #function)
        mockClient.execute(request: mockNormalRequest, model: Int.self) { _, error in
            if error != nil {
               XCTAssertTrue(true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
         wait(for: [exp], timeout: 1.0)
    }
}
struct MockModel: Codable {
}
