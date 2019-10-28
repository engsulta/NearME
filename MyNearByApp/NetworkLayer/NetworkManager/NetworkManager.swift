//
//  NetworkManager.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation

typealias VFGNetworkCompletion = ( Codable?, Error? ) -> Void
protocol NetworkManager {
    /// The URL of the EndPoint at the server.
    var baseUrl: String { get }
    /// A dictionary containing all the Client Related HTTP header fields (default: nil)
    var headers: [String: String]? { get }
    /// The session used during HTTP request (default: URLSession.shared)
    var session: URLSessionProtocol { get }
    /// the authClientProvider module may be injected
    var authClientProvider: AuthTokenProvider? { get set }
    /// The HTTP request timeout.
    var timeout: TimeInterval { get }
    ///start network execution to start http request
    func execute<T: Codable>(request: VFGRequestProtocol, model: T.Type, completion: @escaping VFGNetworkCompletion)
    func upload<T: Codable, U: Codable>(request: VFGRequestProtocol,
                                        responseModel: T.Type,
                                        uploadModel: U,
                                        completion: @escaping VFGNetworkCompletion)
    func cancel(request: VFGRequestProtocol, completion: @escaping () -> Void)
}

enum Result<NetworkError> {
    case success
    case failure(VFGNetworkResponse)
}
protocol HTTPURLResponseProtocol {
    func handleNetworkResponse() -> Result<VFGNetworkResponse>
}
