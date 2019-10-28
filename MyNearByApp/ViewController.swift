//
//  ViewController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/28/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /// jsut for testing that data recieved correctly
       let venueUseCase = VenueListUseCase()
        venueUseCase.fetcNearByVenues { (venues, error) in
            if let error = error{
                print(error.localizedDescription)
            }else if let venues = venues{
                print(venues)
            }
        }
    }


}

