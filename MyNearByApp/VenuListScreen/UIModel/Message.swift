//
//  Message.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var messageTxt: String
    var messageImage: UIImage
    init(error: NetworkRequestError) {
        switch error {
        case .noInternetConnection:
            self.messageTxt = "Something Wrong"
            if #available(iOS 13.0, *) {
                self.messageImage = UIImage(systemName: "exclamationmark.icloud") ?? UIImage()
            } else {
                self.messageImage = UIImage(named: "noInternetConnection") ?? UIImage()
            }
        case .wrongData:
            self.messageTxt = "No available Venues in your place"
            if #available(iOS 13.0, *) {
                self.messageImage = UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
            } else {
                self.messageImage = UIImage(named: "cloud") ?? UIImage()
            }
        default:
            self.messageTxt = "No available Venues in your place"
            self.messageImage = UIImage(named: "cloud") ?? UIImage()
        }
    }
}
