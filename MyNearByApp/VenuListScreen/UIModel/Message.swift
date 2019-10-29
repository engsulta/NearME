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
            self.messageImage = UIImage(named: "noInternetConnection") ?? UIImage()
        case .wrongData:
            self.messageTxt = "No available Venues in your place"
            self.messageImage = UIImage(named: "wrongData") ?? UIImage()
        default:
            self.messageTxt = "No available Venues in your place"
            self.messageImage = UIImage(named: "wrongData") ?? UIImage()
        }
    }
}
