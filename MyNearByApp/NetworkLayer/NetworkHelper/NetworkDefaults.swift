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
    static let clientID = "DANSQAPH5IIJRBMGPGWS3S4M1ZRKLRA4Z44A1UXFORE1SYNG"
    static let clientSecret = "CVCFAPEUDCS0LPR2VW14DIR2Z1KZAAZD23XVMN12YZEIEKER"
    static let apiVersion = "20190425"
}

