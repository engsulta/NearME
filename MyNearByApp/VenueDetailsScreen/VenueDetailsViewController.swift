//
//  VenueDetailsViewController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/19/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class VenueDetailsViewController: UIViewController, Storyboarded {
      // MARK:- properties
    weak var coordinatorDelegate: Coordinator?
    var venueDetailsViewModel: VenueDetailsViewModel? {
        didSet{
            venueimage.image = venueDetailsViewModel?.image
            venueName.text = venueDetailsViewModel?.name
            venueCityLabel.text = venueDetailsViewModel?.city
            venueLat.text = String(venueDetailsViewModel?.lat ?? 0)
            venueLongLabel.text = String(venueDetailsViewModel?.long ?? 0)
        }
    }
    // MARK:- IBoutletss
    
    @IBOutlet weak var venueimage: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!
    @IBOutlet weak var venueCityLabel: UILabel!
    @IBOutlet weak var venueLat: UILabel!
    @IBOutlet weak var venueLongLabel: UILabel!
    @IBOutlet weak var showOverlayButton: UIButton!
     
    
    // MARK:- IBActions
    @IBAction func showOverlayView(_ sender: Any) {
    }
    
    // MARK:- Instance Methods
    func updateView(with model: VenueDetailsViewModel?){
        guard let model = model else {
            // we can handel here empty model
            return
        }
        // inject view model
        self.venueDetailsViewModel = model
    }
}
