//
//  ErrorViewController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/11/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
class ErrorViewController: UIViewController, Storyboarded {
    var coordinatorDelegate: Coordinator?
    @IBOutlet weak var warningImage: UIImageView!
    @IBAction func tryAgainPressed(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
    @IBOutlet weak var warningLabel: UILabel!
    func setupkErrorScreen(with message: Message){
        warningLabel?.text = message.messageTxt
        warningImage?.image = message.messageImage
        
    }
}
