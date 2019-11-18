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
    var navigationController: UINavigationController? { get set }
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: NavigationClosure?)
    func dismiss(animated: Bool)
}

public class NavigationRouter: NSObject {
    public var navigationController: UINavigationController?
    private let routerRootController: UIViewController?
    private var onDismissForViewController:
        [UIViewController: NavigationClosure] = [:]
    private var onCompletionForViewController: [UIViewController: () -> Void] = [:]
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        navigationController.delegate = self
        
    }
}
extension NavigationRouter: Router {
    public func present(_ viewController: UIViewController,
                        animated: Bool,
                        onCompletion: NavigationClosure?,
                        onDismissed: NavigationClosure?) {
        
        onDismissForViewController[viewController] = onDismissed
        onCompletionForViewController[viewController] = onCompletion
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController?.popToRootViewController( animated: animated)
            return
        }
        performOnDismissed(for: routerRootController)
        navigationController?.popToViewController(routerRootController, animated: animated)
    }
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
    private func performOnCompletion(for viewController: UIViewController) {
        guard let onCompletion = onCompletionForViewController[viewController] else { return }
        onCompletion()
        onCompletionForViewController[viewController] = nil
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationRouter: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        /// on poping completed
        if let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) {
            performOnDismissed(for: dismissedViewController)
        }
        
        /// on pushing completed
        if let presentedViewController = navigationController.transitionCoordinator?.viewController(forKey: .to), navigationController.viewControllers.contains(presentedViewController) {
            performOnCompletion(for: presentedViewController)
        }
    }
}
