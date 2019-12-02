//
//  CustomNavigationViewControllerAnimator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/22/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit

open class ViewControllerAnimator: NSObject {
    
    open var isPush = false
    open var transitionDuration: Double
    open var animationType: AnimationType
    public enum AnimationType {
        case present
        case dismiss
    }
    public init(within duration: Double, using animationType: AnimationType) {
        self.transitionDuration = duration
        self.animationType = animationType
    }
    
}

extension ViewControllerAnimator: UIViewControllerAnimatedTransitioning {
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: transitionDuration) ?? 0
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1- get from and to viewcontroller
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(true)
                return
        }
        switch animationType {
        case .present:
            // containerView setup
            presentAnimation(using: transitionContext, animatingTo: toViewController, animatingFrom: fromViewController)
        case .dismiss:
            break
        }
    }
    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning, animatingTo toViewController: UIViewController, animatingFrom fromViewController: UIViewController){
        let containerView = transitionContext.containerView
            let containerViewFrame = containerView.frame
            
            var offScreenRightFrame = containerViewFrame
            offScreenRightFrame.origin.x = -containerView.frame.width * (isPush ? -1 : 1)
            toViewController.view.frame = offScreenRightFrame
            
            guard var offScreenLeftFrame: CGRect = fromViewController.view?.frame else {
                print("Cannot unwrap fromViewController?.view?.frame")
                return
            }
            offScreenLeftFrame.origin.x = -containerView.frame.width * (isPush ? 1 : -1)
            
            if let toViewControllerView = toViewController.view {
                containerView.addSubview(toViewControllerView)
            } else {
                print("animateTransition toViewController?.view optional is empty")
            }
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           usingSpringWithDamping: 1.5,
                           initialSpringVelocity: 1.8,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                            toViewController.view.frame = containerViewFrame
                            fromViewController.view.frame = offScreenLeftFrame
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
}

extension UIView {
    func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

