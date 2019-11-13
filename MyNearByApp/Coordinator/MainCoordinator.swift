//
//  MainCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/12/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationVC: UINavigationController) {
        self.navigationController = navigationVC
        self.childCoordinators = [Coordinator]()
    }
    func start() {
        guard let venueListViewController = VenueListViewController.instantiate() else { return }
        venueListViewController.coordinatorDelegate = self
        navigationController.pushViewController(venueListViewController, animated: true)
    }
    
    /// handle error message transition
    func showWarningViewController(with message: Message){
        guard let errorViewController = ErrorViewController.instantiate() else { return }
        if #available(iOS 13, *){
            errorViewController.modalPresentationStyle = .fullScreen
            navigationController.present(errorViewController,
                                     animated: true,
                                     completion: {
                 errorViewController.setupkErrorScreen(with: message)
            })
        } else {
            let errorViewController = UIAlertController(title: message.messageTxt, message: message.messageTxt, preferredStyle: .alert)
             navigationController.present(errorViewController, animated: true, completion: nil)
        }
    }
}
