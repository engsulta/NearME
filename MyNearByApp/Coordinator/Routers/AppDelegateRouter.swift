//
//  AppDelegateRouter.swift
//  TestableNavigationModule
//
//  Created by Ahmed Sultan on 11/15/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
public class AppDelegateRouter: Router {
    
    // MARK: - Instance Properties
    public let window: UIWindow
    public var navigationController: CustomNavigationController?

    // MARK: - Object Lifecycle
    public init(window: UIWindow) {
        self.window = window }
    
    
    // MARK: - Router
    public func present(_ viewController: UIViewController,
                        animated: Bool,
                        onCompletion: NavigationClosure?,
                        onDismissed: NavigationClosure?) {
        navigationController = CustomNavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
    public func dismiss(animated: Bool) {
        // don't do anything
    }
    
}
