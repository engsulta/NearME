//
//  MainCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/12/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

// this is the main coordinator
class VenueListCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var router: Router
    var navigationController: UINavigationController?
     
    required init(navigationRouter: Router) {
        self.router = navigationRouter
        super.init()
    }
    
    func present(animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: NavigationClosure?) {
        guard let venueListViewController = VenueListViewController.instantiate(delegate: self) else { return }
        venueListViewController.viewModel = VenueListViewModel()
        venueListViewController.warningCoordinatorDelegate = self
        venueListViewController.venueDetailsCoordinatorDelegate = self
        router.present(venueListViewController,
                       animated: animated,
                       onCompletion: onCompletion,
                       onDismissed: onDismissed)
        navigationController = UINavigationController()
    }
}

extension VenueListCoordinator: WarningMessageDelegate {
   /// handle error message transition
   func showWarningViewController(with message: Message) {
       if let parentVC = router.navigationController?.viewControllers.last {
           let warningScreenCoordinator = WarningScreenCoordinator(navigationRouter: ModalNavigationRouter(parentViewController: parentVC))
           warningScreenCoordinator.message = message
           presentChild(warningScreenCoordinator, animated: true, onCompletion: nil)
       }
   }
}

extension VenueListCoordinator: DetailsViewDelegate {
    /// navigate to venue details screen
    func displayDetails(for venueModel: VenueDetailsViewModel?) {
        let detailsScreenCoordinator = VenueDetailsCoordinator(navigationRouter: NavigationRouter(navigationController: router.navigationController ))
        detailsScreenCoordinator.cellModel = venueModel
        presentChild(detailsScreenCoordinator, animated: true, onCompletion: nil)
    }
}



protocol DetailsViewDelegate: class {
     func displayDetails(for venueModel: VenueDetailsViewModel?)
}
protocol WarningMessageDelegate: class {
    func showWarningViewController(with message: Message)
}
