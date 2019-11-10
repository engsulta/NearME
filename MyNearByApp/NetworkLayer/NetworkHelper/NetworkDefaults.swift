//
//  NetworkDefaults.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
struct NetworkDefaults {
    static let httpMethod: HTTPMethod = .get
    static let parameters: Parameters = [:]
    static let httpHeaders: HTTPHeaders? = nil
    static let cashPolicy: CashPolicy = .reloadIgnoringLocalCacheData
    static let path: String = String("")
    static let networkWorkerQueue: DispatchQueue = DispatchQueue.global(qos: .default)
   
    
}

struct NetworkKeys {
    static let clientIDKey = "client_id"
    static let clientSecretKey = "client_secret"
    static let apiVersionKey = "v"
    static let clientID = "5ZAEXI4DAWUTFI2DCTI4JWWZNWYTLXFZPZK1EAR3ENHCRSLR"
    static let clientSecret = "A5Y3BH1GFVIYARKTKIXKR1DMWOQYKBEV4HNP1TAXRMY4MFHB"
    static let apiVersion = "20190425"
}

