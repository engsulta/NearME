//
//  URLSessionMock.swift
//  NetworkServicesTests
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
@testable import MyNearByApp

class URLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
    }
}

class URLSessionMock: URLSessionProtocol {
    var urlSessionDataTaskMock =  URLSessionDataTaskMock()
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        if let requestUrl = request.url {
        if let url = Bundle.unitTest.url(forResource: "NetworkTest", withExtension: ".json") {
            do {
                let data = try Data(contentsOf: url)
                let succesResponse = HTTPURLResponse(url: requestUrl,
                                                     statusCode: 200,
                                                     httpVersion: nil,
                                                     headerFields: nil)
                completionHandler(data, succesResponse, nil)
            } catch {
                completionHandler(nil, nil, NetworkResponse.noData)
            }
        } else {
            completionHandler(nil, nil, NetworkResponse.noData)
            }
        }
        return urlSessionDataTaskMock
    }
}
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var isResumedCalled = false

    func resume() {
        isResumedCalled = true
    }
}

extension Bundle {
    private class VFGTest {}
    
    public class var unitTest: Bundle {
        return Bundle(for: VFGTest.self)
    }
    
    func urlSchemes(with urlName: String) -> [String] {
        let urlTypes = infoDictionary?["CFBundleURLTypes"] as? [Any]
        let urlSchema = urlTypes?.first(where: { (element) -> Bool in
            guard let urlDict = element as? [String: Any] else {
                return false
            }
            return urlDict["CFBundleURLName"] as? String == urlName
        }) as? [String: Any]
        
        return urlSchema?["CFBundleURLSchemes"] as? [String] ?? []
    }
    
}

