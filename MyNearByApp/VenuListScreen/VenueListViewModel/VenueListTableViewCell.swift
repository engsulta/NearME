//
//  VenueListTableViewCell.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class VenueListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!
    var venueListCellViewModel : VenueListCellViewModel? {
        didSet {
            nameLabel.text = venueListCellViewModel?.titleText
            descriptionLabel.text = venueListCellViewModel?.descText
            //mainImageView?.sd_setImage(with: URL( string: venueListCellViewModel?.imageUrl ?? "" ), completed: nil)
            mainImageView?.image = UIImage()
            dateLabel.text = venueListCellViewModel?.dateText
        }
    }
}
