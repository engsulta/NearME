//
//  VenueListCellViewModel.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

struct VenueListCellViewModel {
    let titleText: String
    let addressText: String
    let imageUrl: String
    let venueId: String
}

struct VenueDetailsViewModel {
    let name: String
    let address: String
    var image: UIImage?
    let city: String
    let lat: Float
    let long: Float
}
