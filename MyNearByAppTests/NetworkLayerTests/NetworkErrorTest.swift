//
//  VFGNetworkErrorTest.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/21/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import XCTest
@testable import VFGFoundation
class VFGNetworkErrorTest: XCTestCase {
    func testNetworkErrorLocalizedDescription() {
        let expected: [String] = ["Unable to parse response",
                                  "Network operation failed",
                                  "Empty response",
                                  "missing URL",
                                  "encodingFailed",
                                  "Unknown",
                                  "Authentication token missed",
                                  "no Internet Connection"]

        for (index, testError) in [VFGNetworkError.parse,
                                   VFGNetworkError.network,
                                   VFGNetworkError.empty,
                                   VFGNetworkError.missingURL,
                                   VFGNetworkError.encodingFailed,
                                   VFGNetworkError.unknown,
                                   VFGNetworkError.authFailed,
                                   VFGNetworkError.noInternetConnection].enumerated() {
                                    XCTAssertEqual(testError.rawValue, expected[index])
        }
    }

    func testNetworkResponseErrorLocalizedDescription() {
        let expected: [String] = ["You need to be authenticated first.",
                                  "Bad request",
                                  "server encountered an unexpected condition",
                                  "The url you requested is outdated.",
                                  "Network request failed.",
                                  "Response returned with no data to decode.",
                                  "We could not decode the response."]
        for (index, testError) in [VFGNetworkResponse.authenticationError,
                                   VFGNetworkResponse.badRequest,
                                   VFGNetworkResponse.serverError,
                                   VFGNetworkResponse.outdated,
                                   VFGNetworkResponse.failed,
                                   VFGNetworkResponse.noData,
                                   VFGNetworkResponse.unableToDecode].enumerated() {
                                    XCTAssertEqual(testError.rawValue, expected[index])
        }
    }
}
