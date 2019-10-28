//
//  NetworkDefaults.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
struct NetworkDefaults {
    public static let timeOut: TimeInterval = 10
    public static let httpMethod: HTTPMethod = .get
    public static let parameters: Parameters = [:]
    public static let httpHeaders: HTTPHeaders? = nil
    public static let cashPolicy: CashPolicy = .reloadIgnoringLocalCacheData
    public static let path: String = String("")
    public static let networkWorkerQueue: DispatchQueue = DispatchQueue.global(qos: .default)
}
