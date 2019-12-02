//
//  Router.swift
//  TestableNavigationModule
//
//  Created by Ahmed Sultan on 11/15/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
public typealias NavigationClosure = (() -> Void)
public protocol Router: class {
    var navigationController: CustomNavigationController? { get set }
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: NavigationClosure?)
    func dismiss(animated: Bool)
}

public class NavigationRouter: NSObject {
    public var navigationController: CustomNavigationController?
    private let routerRootController: UIViewController?
    public init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
        self.routerRootController = navigationController?.viewControllers.first
        super.init()
       //navigationController?.delegate = self
    }
}
extension NavigationRouter: Router {
    public func present(_ viewController: UIViewController,
                        animated: Bool,
                        onCompletion: NavigationClosure?,
                        onDismissed: NavigationClosure?) {
        
        navigationController?.onDismissForViewController[viewController] = onDismissed
        navigationController?.onCompletionForViewController[viewController] = onCompletion
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController?.popToRootViewController( animated: animated)
            return
        }
        navigationController?.performOnDismissed(for: routerRootController)
        navigationController?.popToViewController(routerRootController, animated: animated)
    }
}
//
//// MARK: - UINavigationControllerDelegate
//extension NavigationRouter: UINavigationControllerDelegate {
//    public func navigationController(
//        _ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        /// on poping completed
//        if let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) {
//            performOnDismissed(for: dismissedViewController)
//        }
//
//        /// on pushing completed
//        if let presentedViewController = navigationController.transitionCoordinator?.viewController(forKey: .to), navigationController.viewControllers.contains(presentedViewController) {
//            performOnCompletion(for: presentedViewController)
//        }
//    }
//}
