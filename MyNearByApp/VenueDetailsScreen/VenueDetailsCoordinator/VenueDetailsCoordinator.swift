//
//  VenueDetailsCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/19/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

// this is the main coordinator
class VenueDetailsCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var router: Router
    var cellModel: VenueDetailsViewModel?
    
    required init(navigationRouter: Router) {
        self.router = navigationRouter
        super.init()
    }
    
    func present(animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: NavigationClosure?) {
    
        guard let venueDetailsViewController = VenueDetailsViewController.instantiate(delegate: self) else {
            return
        }
        let completionBlock: NavigationClosure = {
            venueDetailsViewController.updateView(with: self.cellModel)
            onCompletion?()
        }
        let back = UIBarButtonItem(image: UIImage(named: "arrow.left"), style: .plain, target: self, action: #selector(backPressed))
        router.navigationController?.navigationItem.leftBarButtonItem = back

        router.present(venueDetailsViewController,
                       animated: animated,
                       onCompletion: completionBlock,
                       onDismissed: onDismissed)
    }
    @objc func backPressed(){
        
    }
    func showAlertViewController(with message: Message) {
//        if let parentVC = router.navigationController?.viewControllers.last {
//            let warningScreenCoordinator = WarningScreenCoordinator(navigationRouter: ModalNavigationRouter(parentViewController: parentVC))
//            warningScreenCoordinator.message = message
//            presentChild(warningScreenCoordinator, animated: true, onCompletion: nil)
//        }
    }
}
