//
//  URLSessionMock.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/20/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
@testable import VFGFoundation

class URLSessionDataTask: URLSessionDataTaskProtocol {
    func suspend() {
    }
    func resume() {
    }
    func cancel() {
    }
}

class URLSessionMock: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        // check url while testing then return corresponding completion it depends on your use 
         completionHandler(nil, nil, nil)
         return urlSessionDataTaskMock
    }

    var urlSessionDataTaskMock =  URLSessionDataTaskMock()
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        if let requestUrl = request.url {
        if let url = Bundle.unitTest.url(forResource: "VFGNetworkTest", withExtension: ".json") {
            do {
                let data = try Data(contentsOf: url)
                let succesResponse = HTTPURLResponse(url: requestUrl,
                                                     statusCode: 200,
                                                     httpVersion: nil,
                                                     headerFields: nil)
                completionHandler(data, succesResponse, nil)
            } catch {
                completionHandler(nil, nil, VFGNetworkResponse.noData)
            }
        } else {
            completionHandler(nil, nil, VFGNetworkResponse.noData)
            }
        }
        return urlSessionDataTaskMock
    }
    func uploadTask(with request: URLRequest,
                    from data: Data,
                    completionHandler: @escaping DataTaskResult) -> URLSessionUploadTaskProtocol {
        completionHandler(nil, nil, nil)
        return URLSessionUploadTask()
    }
}
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var isCancelledCalled = false
    var isResumedCalled = false
    var isSuspendCalled = false

    func resume() {
        isResumedCalled = true
        isCancelledCalled = false
        isSuspendCalled = false
    }
    func suspend() {
        isSuspendCalled = true
        isCancelledCalled = false
        isResumedCalled = false
    }
    func cancel() {
        isCancelledCalled = true
        isResumedCalled = false
        isSuspendCalled = false
    }
}
