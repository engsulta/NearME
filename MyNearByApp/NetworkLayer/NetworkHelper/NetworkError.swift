//
//  NetworkError.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation

public enum NetworkRequestError: String, Error {
    case missingURL = "missing URL"
    case encodingFailed = "encodingFailed"
    case noInternetConnection = "no Internet Connection"
}
public enum NetworkResponse: String, Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case serverError = "server encountered an unexpected condition"
    case unknown = "unknown error"
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
class NetworkLogger {
    static func log(request: URLRequest) {
        print("\n - - - - - - - - - - Request - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        for queryItem in urlComponents?.queryItems ?? [] {
            logOutput += "\(queryItem.name): \(String(describing: queryItem.value)) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        print(logOutput)
}
    static func log(response: HTTPURLResponse) {
        print("\n - - - - - - - - - - Response - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n")}
       
        var logOutput = "\nResponse_Headers: "
        for (key, value) in response.allHeaderFields {
            logOutput += "\(key): \(value) \n"
        }
        let statusCode = String(response.statusCode)
        logOutput += "\nResponse_statusCode: \(statusCode)"
        let mimeType = response.mimeType ?? ""
        logOutput += "\nResponse_mimeType: \(mimeType)"
        let desctription = response.description
        logOutput += "\nResponse: \(desctription)"
        print(logOutput)
    }
}
