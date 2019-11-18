//
//  VenueListCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/13/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

class WarningScreenCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var router: Router
    var message: Message?
    
    
    required init(navigationRouter: Router) {
        self.router = navigationRouter
    }
    
    func present(animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: (() -> Void)?) {

        guard let errorViewController = ErrorViewController.instantiate(delegate: self) else { return }
        let onComplete: NavigationClosure = {
                        errorViewController.setupkErrorScreen(with: self.message ?? Message(error: .noInternetConnection))
                   }
        if #available(iOS 13, *){
            errorViewController.modalPresentationStyle = .fullScreen
            router.present(errorViewController,
                           animated: true, onCompletion: onComplete,
                           onDismissed: nil)
        } else {
            let errorViewController = UIAlertController(title: "message.messageTxt", message: "message.messageTxt", preferredStyle: .alert)
            router.present(errorViewController, animated: true, onCompletion: onComplete, onDismissed: nil)
        }
    }
}
