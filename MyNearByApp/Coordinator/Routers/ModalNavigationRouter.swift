//
//  ModalRouter.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/16/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

public class ModalNavigationRouter: NSObject {

    public unowned let parentViewController: UIViewController
    public var navigationController: CustomNavigationController? = CustomNavigationController()
    
    // MARK: - Object Lifecycle
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        //navigationController?.delegate = self
    }
}


// MARK: - Router
extension ModalNavigationRouter: Router {
    public func present(_ viewController: UIViewController,
                        animated: Bool,
                        onCompletion: NavigationClosure?,
                        onDismissed: NavigationClosure?) {
        
        navigationController?.onDismissForViewController[viewController] = onDismissed
        navigationController?.onCompletionForViewController[viewController] = onCompletion
        
        if navigationController?.viewControllers.count == 0 {
            presentModally(viewController,
                           animated: animated,
                           onCompletion: onCompletion)

        } else {
            navigationController?.pushViewController(viewController, animated: animated)
        }
    }

    private func presentModally(_ viewController: UIViewController, animated: Bool, onCompletion: NavigationClosure?) {

        //addCancelButton(to: viewController)
        navigationController?.setViewControllers( [viewController], animated: false)
        navigationController?.modalPresentationStyle = viewController.modalPresentationStyle
        navigationController?.isNavigationBarHidden = true
        parentViewController.present(navigationController!,
                                     animated: animated,
                                     completion: onCompletion)
    }
    private func addCancelButton(to viewController: UIViewController) {
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                          style: .plain,
                                                                          target: self,
                                                                          action: #selector(cancelPressed))
    }
    @objc private func cancelPressed() {
//        guard let viewcontroller = navigationController?.viewControllers.first else { return }
//        performOnDismissed(for: viewcontroller)
        dismiss(animated: true)
    }
    
    public func dismiss(animated: Bool) {
        guard let viewcontroller = navigationController?.viewControllers.first else { return }
        performOnDismissed(for: viewcontroller)
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        if let onDismiss = navigationController?.onDismissForViewController[viewController] {
        onDismiss()
        navigationController?.onDismissForViewController[viewController] = nil
        }
    }
    private func performOnCompletion(for viewController: UIViewController) {
           guard let onCompletion = navigationController?.onCompletionForViewController[viewController] else { return }
           onCompletion()
           navigationController?.onCompletionForViewController[viewController] = nil
       }
}
//
//// MARK: - UINavigationControllerDelegate
//extension ModalNavigationRouter: UINavigationControllerDelegate {
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
