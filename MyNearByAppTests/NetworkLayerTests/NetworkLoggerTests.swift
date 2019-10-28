//
//  NetworkLoggerTests.swift
//  NetworkServicesTests
//
//  Created by Atta Amed on 10/21/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import XCTest
@testable import VFGFoundation

class NetworkLoggerTests: XCTestCase {

    let session = URLSessionMock()
    var mockClient: VFGNetworkClient!
    var mockRequest: VFGRequestProtocol!

    override func setUp() {
        super.setUp()
        mockClient = VFGNetworkClient(baseURL: "www.test.com", session: session)
        mockRequest = VFGRequest(path: "www.test.com", httpMethode: .get,
                                 httpTask: .request,
                                 headers: ["test": "test"],
                                 isAuthenticationNeededRequest: false,
                                 cachePolicy: .reloadIgnoringLocalCacheData)
    }

    func testLogRequest( ) {
        let url = URL(string: "www.test.com")
        guard let request = (try? mockClient.buildRequest(from: mockRequest, with: [:], to: url)) else {
            XCTFail("fail to create request")
            return
        }
        VFGNetworkLogger.log(request: request)
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
        VFGNetworkLogger.log(response: response)
    }

    func testLogJson() {
        let testParmaters = ["name": "atta"]
        VFGNetworkLogger.log(jsonResponse: testParmaters )
    }

    override func tearDown() {
        mockClient = nil
        mockRequest = nil
        super.tearDown()
    }
}
