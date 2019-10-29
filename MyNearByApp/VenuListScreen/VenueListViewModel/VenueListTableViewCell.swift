//
//  VenueListTableViewCell.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class VenueListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    var venueListCellViewModel : VenueListCellViewModel? {
        didSet {
            nameLabel.text = venueListCellViewModel?.titleText
            addressLabel.text = venueListCellViewModel?.addressText
            
            mainImageView?.sd_setImage(with: URL(string: "https://fastly.4sqi.net/img/general/500x500/379781209_XsgqUBnFSSYrFtvEGO6L8FF5Tong_YodCtmGtkT997k.jpg" ),
                                       completed: nil)
        }
    }
}
//"https://fastly.4sqi.net/img/general/500x500/379781209_XsgqUBnFSSYrFtvEGO6L8FF5Tong_YodCtmGtkT997k.jpg"
//https://api.foursquare.com/v2/venues/{{VENUE_ID}}/photos?client_id={{client_id}}&client_secret={{client_secret}}&v={{v}}&group=venue&limit=10
