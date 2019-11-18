//
//  VenueListCoordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/13/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

enum ChildScreens {
    case errorScreen(message: Message)
    case anotherScreen
}
class WarningScreenCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var startScreen: ChildScreens?
    
    init(navigationVC: UINavigationController) {
        self.navigationController = navigationVC
        self.childCoordinators = [Coordinator]()
    }
    
    func start() {
        switch startScreen {
        case let .errorScreen(message):
            guard let errorViewController = ErrorViewController.instantiate() else { return }
            errorViewController.coordinatorDelegate = self
            
            if #available(iOS 13, *){
                errorViewController.modalPresentationStyle = .fullScreen
                navigationController.present(errorViewController,
                                             animated: true,
                                             completion: {
                                                errorViewController.setupkErrorScreen(with: message)
                })
            } else {
                let errorViewController = UIAlertController(title: "message.messageTxt", message: "message.messageTxt", preferredStyle: .alert)
                navigationController.present(errorViewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
}
