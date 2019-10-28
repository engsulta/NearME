//
//  EndPointRequest.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]
public typealias CashPolicy = URLRequest.CachePolicy

/**
 Network Generic EndPoint protocol used By business layer to create network Requests.
 */
protocol RequestProtocol {
    /// The relative Endpoint path added to baseUrl
    var path: String {get}
    /// The HTTP request method
    var httpMethode: HTTPMethod {get}
    /// Http task create encoded data sent as the message body of a request, such as for an HTTP POST request or
    /// inline in case of HTTP GET request (default: .request)
    var parameters: Parameters {get}
    /// A dictionary containing all the request’s HTTP header fields related to such endPoint(default: nil)
    var headers: HTTPHeaders? {get}
    ///The constants enum used to specify interaction with the cached responses.
    /** Specifies that the caching logic defined in the protocol implementation, if any, is
     used for a particular URL load request. This is the default policy
     for URL load requests.*/
    var cachePolicy: CashPolicy { get }
}

/// Concrete implementation to App Request
struct NearByRequest: RequestProtocol {
    public var path: String
    public var httpMethode: HTTPMethod
    public var parameters: Parameters
    public var headers: HTTPHeaders?
    public var cachePolicy: CashPolicy
    
    init(path: String = NetworkDefaults.path,
         httpMethode: HTTPMethod = NetworkDefaults.httpMethod,
         parameters: Parameters = NetworkDefaults.parameters,
         headers: HTTPHeaders? = NetworkDefaults.httpHeaders,
         cachePolicy: CashPolicy = NetworkDefaults.cashPolicy) {
        self.path = path
        self.httpMethode = httpMethode
        self.parameters = parameters
        self.headers = headers
        self.cachePolicy = cachePolicy
    }
}
enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    case options = "OPTIONS"
}
