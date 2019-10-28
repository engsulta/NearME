//
//  URLSessionProtocol.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
/// URL data task protocol will be used to inject session to network
///as we have real session or mock session
protocol URLSessionDataTaskProtocol {
    func resume()
}

/// URL session protocol will be used to inject session to network
///as we have real session or mock session
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    /// loading remote request data task
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

/// extension for real session to implement our own protocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    /// remote task
     func dataTask(with request: URLRequest,
                         completionHandler: @escaping URLSessionProtocol.DataTaskResult)
        -> URLSessionDataTaskProtocol {
            return dataTask(with: request,
                            completionHandler: completionHandler) as URLSessionDataTask
    }
}
