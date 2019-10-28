//
//  VFGNetworkErrorTest.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import XCTest
@testable import MyNearByApp
class NetworkErrorTest: XCTestCase {
    func testNetworkErrorLocalizedDescription() {
        let expected: [String] = [
                                  "missing URL",
                                  "encodingFailed",
                                  "no Internet Connection"]

        for (index, testError) in [
                                   NetworkRequestError.missingURL,
                                   NetworkRequestError.encodingFailed,
                                   NetworkRequestError.noInternetConnection].enumerated() {
                                    XCTAssertEqual(testError.rawValue, expected[index])
        }
    }

    func testNetworkResponseErrorLocalizedDescription() {
        let expected: [String] = ["You need to be authenticated first.",
                                  "Bad request",
                                  "server encountered an unexpected condition",
                                  "Response returned with no data to decode.",
                                  "We could not decode the response."]
        for (index, testError) in [NetworkResponse.authenticationError,
                                   NetworkResponse.badRequest,
                                   NetworkResponse.serverError,
                                   NetworkResponse.noData,
                                   NetworkResponse.unableToDecode].enumerated() {
                                    XCTAssertEqual(testError.rawValue, expected[index])
        }
    }
}
