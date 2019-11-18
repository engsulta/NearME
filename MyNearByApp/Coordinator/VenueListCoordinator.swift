//
//  MainCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/12/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class VenueListCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationVC: UINavigationController) {
        self.navigationController = navigationVC
        self.childCoordinators = [Coordinator]()
    }
    /// each coordinator responsible for creation of the viewController itself + set its coordinator delegate with an object
    func start() {
        guard let venueListViewController = VenueListViewController.instantiate() else { return }
        venueListViewController.coordinatorDelegate = self
        navigationController.pushViewController(venueListViewController, animated: true)
    }
    
    /// handle error message transition
    func showWarningViewController(with message: Message) {
        let childCoordinator = VenueListCoordinator(navigationVC: self.navigationController)
        childCoordinators.append(childCoordinator)
        childCoordinator.startScreen = ChildScreens.errorScreen(message: message)
        childCoordinator.start()
    }
}
