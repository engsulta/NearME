//
//  CustomNavigationController.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/22/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit

public protocol navigationDelegate {
    func setupBackground()
    func setTransitionAnimaiton()
    func setupNavigationBar()
}
public class CustomNavigationController: UINavigationController {
    
    // MARK:- static private lets
    private static let LevelOneImageName: String = "bg_l1"
    private static let LevelTwoImageName: String = "bg_l2"
    
    
    
    // MARK: properties
    private var fadingOutBackgroundImageView = UIImageView()
    private var fadingInBackgroundImageView = UIImageView()
    public var onDismissForViewController:
        [UIViewController: NavigationClosure] = [:]
    public var onCompletionForViewController: [UIViewController: () -> Void] = [:]
    
    public var backGroundAnimation: Bool = true
    public var backgroundImage: UIImage? {
        didSet {
            displayedBackgroundImage = backgroundImage
        }
    }
    fileprivate var displayedBackgroundImage: UIImage? {
        willSet (newValue) {
            if self.displayedBackgroundImage != newValue {
                if self.displayedBackgroundImage != nil {
                    print("Replacing previous displayBackgroundImage property")

                    self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    self.fadingOutBackgroundImageView.alpha = 1

                    self.fadingInBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.alpha = 0
                    if backGroundAnimation {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.fadingInBackgroundImageView.alpha = 1
                    }, completion: { (_) in
                        self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    })
                    } else {
                      self.fadingInBackgroundImageView.alpha = 1
                         self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    }
                } else {
                    print("Configuring new displayBackgroundImage property")

                    self.fadingOutBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.image = newValue
                }
            }
        }
    }
     // MARK:- Setup background
    private func setupBackground() {
        fadingInBackgroundImageView.frame = view.bounds
        fadingInBackgroundImageView.alpha = 0
        
        fadingOutBackgroundImageView.frame = view.bounds
        fadingOutBackgroundImageView.alpha = 1
        
        view.addSubview(fadingInBackgroundImageView)
        view.addSubview(fadingOutBackgroundImageView)
        view.sendSubviewToBack(fadingInBackgroundImageView)
        view.sendSubviewToBack(fadingOutBackgroundImageView)
        updateBackgroundFor(viewControllers: viewControllers)
    }

    // MARK:- LifeCycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupBackground()
        addPanGestureForPopTransitioning()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
          super.traitCollectionDidChange(previousTraitCollection)
          if #available(iOS 13.0, *) {
              if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                  // do your customization here
                  updateBackgroundFor(viewControllers: viewControllers)
              }
          }
    }
    
    // MARK: - hadndle Background Logic
    /**
     while transition through the app background will be changed from first level to second level
    */
    fileprivate func updateBackgroundFor(viewControllers: [UIViewController]) {
        if self.backgroundImage == nil {
            print("BackgroundImage is nil")
            //Transitioning to level 1
            if viewControllers.count < 2 {
                print("Setting level 1 default background image")
                self.displayedBackgroundImage = self.levelOneDefaultBackgroundImage()
            } else {
                //Transitioning to level 2+
                print("Setting level 2 default background image")
                self.displayedBackgroundImage = self.levelTwoDefaultBackgroundImage()
            }
        } else {
            //Use overriding VC background image
            self.displayedBackgroundImage = self.backgroundImage
        }
    }
    
    private func levelOneDefaultBackgroundImage() -> UIImage? {
        let image = UIImage(named: CustomNavigationController.LevelOneImageName, in: nil, compatibleWith: nil)
        let asset = image?.imageAsset
        let levelOneImage = asset?.image(with: traitCollection)
        return levelOneImage
    }

    private func levelTwoDefaultBackgroundImage() -> UIImage? {
        let image = UIImage(named: CustomNavigationController.LevelTwoImageName, in: nil, compatibleWith: nil)
        let asset = image?.imageAsset
        let levelTwoImage = asset?.image(with: traitCollection)
        return levelTwoImage
    }
    
    // MARK:- handle completion and dismiss
    func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
    func performOnCompletion(for viewController: UIViewController) {
        guard let onCompletion = onCompletionForViewController[viewController] else { return }
        onCompletion()
        onCompletionForViewController[viewController] = nil
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    /// control background and navigation item
    @objc public func navigationController(_ navigationController: UINavigationController,
                                           animationControllerFor operation: UINavigationController.Operation,
                                           from fromVC: UIViewController,
                                           to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.updateBackgroundFor(viewControllers: self.viewControllers)
        // viewcontroller animator will handle push and pop animation for all custom navigation controller transition
        let animation = ViewControllerAnimator(within: 0.6, using: .present)
        animation.isPush = (operation == .push)
        return animation
    }
    
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
// swipeable navigation
extension CustomNavigationController {
    func addPanGestureForPopTransitioning() {
        let navigationController = self
        let targets: [AnyObject] = navigationController.interactivePopGestureRecognizer?.value(forKey: "_targets") as! [AnyObject]
        guard let interactivePanTarget = targets.first?.value(forKey: "target")  else {return}
        let pan = UIPanGestureRecognizer(target: interactivePanTarget, action: NSSelectorFromString("handleNavigationTransition:"))
        self.view.addGestureRecognizer(pan)
        self.interactivePopGestureRecognizer?.isEnabled = false
        
    }
}
