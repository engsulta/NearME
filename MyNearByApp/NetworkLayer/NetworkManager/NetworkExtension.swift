//
//  NetworkExtension.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
public typealias ResponseArg = (data: Data?, urlResponse: URLResponse?, error: Error?)
extension NetworkManager {
    func execute<T: Codable>(request: RequestProtocol,
                             model: T.Type,
                             completion: @escaping NetworkCompletion) {
        
        let fullRequestHeaders = buildHeaders(from: request)
        do{
            let urlRequest = try buildRequest(from: request, with: fullRequestHeaders, to: URL(string: baseUrl))
            NetworkLogger.log(request: urlRequest)
            let currentTask = session.dataTask(with: urlRequest, completionHandler: {[weak self] (data, response, error) in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(nil, NetworkResponse.unknown)
                    }
                    return
                }
                self.mapResponse(responseArg: (data, response, error), model: model, completion: completion)
            })
            currentTask.resume()
            
        } catch{
            DispatchQueue.main.async {
                completion(nil, NetworkRequestError.missingURL)
            }
        }
    }
}
extension NetworkManager {
     func mapResponse<T: Codable>(responseArg: ResponseArg,
                                      model: T.Type,
                                      completion: @escaping NetworkCompletion) {
        guard responseArg.error == nil else {
            DispatchQueue.main.async {
                completion(nil, responseArg.error)
            }
            return
        }
        guard  let httpResponse = responseArg.urlResponse as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, NetworkResponse.noData)
                }
            return
        }
        let result = httpResponse.handleNetworkResponse()
        switch result {
        case .success:
            guard let responseData = responseArg.data else {
                DispatchQueue.main.async {
                    completion(nil, NetworkResponse.noData)}
                return
            }
            NetworkLogger.log(response: httpResponse)
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? String
                print(jsonData ?? "")
                let apiResponse = try JSONDecoder().decode(model, from: responseData)
                print(apiResponse)
                DispatchQueue.main.async {
                    completion(apiResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, NetworkResponse.unableToDecode)}
            }
        case let .failure(networkResponseError):
            DispatchQueue.main.async {
                completion(nil, networkResponseError)}
        }
    }
    
     func buildHeaders(from request: RequestProtocol) -> HTTPHeaders {
        var requestClientHeaders: HTTPHeaders = clientHeaders ?? [:]
        request.headers?.forEach {
            requestClientHeaders[$0.key] = $0.value
        }
        return requestClientHeaders
    }
    
     func buildRequest(from endPoint: RequestProtocol,
                              with headers: HTTPHeaders,
                              to baseURL: URL?) throws -> URLRequest {
        guard let baseURL = baseURL else {
            throw NetworkRequestError.missingURL
        }
        var request = URLRequest(url: baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: endPoint.cachePolicy)
        request.allHTTPHeaderFields = headers
        request.httpMethod = endPoint.httpMethode.rawValue
        guard let url = request.url else {throw NetworkRequestError.missingURL}
        guard var urlComponents = URLComponents(url: url,
                                                resolvingAgainstBaseURL: false) else { return request }
        var fullRequestparameters = clientParameters
        endPoint.parameters.forEach {
            fullRequestparameters[$0.key] = "\($0.value)"
        }
        urlComponents.setQueryItems(with: fullRequestparameters)
        
        request.url = urlComponents.url
        return request
    }
    
}
extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key,
                                                        value: "\($0.value)")
        }
    }
}

extension HTTPURLResponse {
    func handleNetworkResponse() -> Result<NetworkResponse> {
        switch self.statusCode {
        case 200...299: return .success
        case 400:       return .failure(NetworkResponse.badRequest)
        case 401...499: return .failure(NetworkResponse.authenticationError)
        case 500...599: return .failure(NetworkResponse.serverError)
        default: return .failure(NetworkResponse.unknown)
        }
    }
}


enum Result<NetworkResponse> {
    case success
    case failure(NetworkResponse)
}
