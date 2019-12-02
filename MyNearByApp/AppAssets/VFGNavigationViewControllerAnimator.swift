//
//  VFGNavigationViewControllerAnimator.swift
//  VFGCommonUI
//
//  Created by Hussien Gamal Mohammed on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import UIKit
import VFGCommonUtils

@objc open class VFGNavigationViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    @objc open var isPush = false
    @objc open var transitionDuration = 0.66

    @objc open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    @objc open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let containerView = transitionContext.containerView

        let containerViewFrame = containerView.frame

        var offScreenRightFrame = containerViewFrame
        offScreenRightFrame.origin.x = -containerView.frame.width * (isPush ? -1 : 1)
        toViewController?.view.frame = offScreenRightFrame

        guard var offScreenLeftFrame: CGRect = fromViewController?.view?.frame else {
            VFGErrorLog("Cannot unwrap fromViewController?.view?.frame")
            return
        }
        offScreenLeftFrame.origin.x = -containerView.frame.width * (isPush ? 1 : -1)

        if let toViewControllerView = toViewController?.view {
            containerView.addSubview(toViewControllerView)
        } else {
            VFGDebugLog("animateTransition toViewController?.view optional is empty")
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 1.5,
                       initialSpringVelocity: 1.8,
                       options: UIView.AnimationOptions(rawValue: 0),
                       animations: {
                        toViewController?.view.frame = containerViewFrame
                        fromViewController?.view.frame = offScreenLeftFrame
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
    }
}
