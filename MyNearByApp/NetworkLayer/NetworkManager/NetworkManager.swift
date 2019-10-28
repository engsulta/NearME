//
//  NetworkManager.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
/// protocol implement our network manager that will execute the requests and return completion to use cases
typealias NetworkCompletion = ( Codable?, Error? ) -> Void
protocol NetworkManagerProtocol {
    /// The URL of the EndPoint at the server.
    var baseUrl: String { get }
    /// A dictionary containing all the Client Related HTTP header fields (default: nil)
    var clientHeaders: HTTPHeaders? {get}
    /// client specific parameters like auth parameters
    var clientParameters: [String: String] { get }
    /// The session used during HTTP request (default: URLSession.shared)
    var session: URLSessionProtocol { get }
    ///start network execution to start http request implemented in default extension to concrete client
    func execute<T: Codable>(request: RequestProtocol, model: T.Type, completion: @escaping NetworkCompletion)
}

// shared concrete Network Client implementation
class NetworkManager: NetworkManagerProtocol {
    var baseUrl: String
    var session: URLSessionProtocol
    /// create default headers per any network request
    var clientParameters: [String: String] {
        let clientID = Bundle.main.object(forInfoDictionaryKey: NetworkKeys.clientIDKey) as? String ?? NetworkKeys.clientID
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: NetworkKeys.clientSecretKey) as? String ?? NetworkKeys.clientSecret
        let apiVersion = Bundle.main.object(forInfoDictionaryKey: NetworkKeys.apiVersionKey) as? String ?? NetworkKeys.apiVersion
        
        return [NetworkKeys.clientIDKey: clientID,
                NetworkKeys.clientSecretKey: clientSecret,
                NetworkKeys.apiVersionKey: apiVersion]
    }
    var clientHeaders: HTTPHeaders? { return nil }
    static let shared: NetworkManager = {
        var serverURL:String = "https://api.foursquare.com"
        return NetworkManager(baseURL: serverURL)
    }()
    
    /// this is a non private init for implementing singletone plus design pattern so we can mock the network manager by creat mock instance with mock session and fake url
     init(baseURL: String, session: URLSessionProtocol = URLSession.shared) {
        self.baseUrl = baseURL
        self.session = session
    }
}
