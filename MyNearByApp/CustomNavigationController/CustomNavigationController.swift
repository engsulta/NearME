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
    private static let morningLevelOneImageName: String = "morning_bg_l1"
    private static let morningLevelTwoImageName: String = "morning_bg_l2"
    private static let eveningLevelOneImageName: String = "evening_bg_l1"
    private static let eveningLevelTwoImageName: String = "evening_bg_l2"
    
    
    // MARK: properties
    private var fadingOutBackgroundImageView = UIImageView()
    private var fadingInBackgroundImageView = UIImageView()
    public var onDismissForViewController:
        [UIViewController: NavigationClosure] = [:]
    public var onCompletionForViewController: [UIViewController: () -> Void] = [:]
    public var nightMode: Bool = false {
        didSet {
            updateBackgroundFor(viewControllers: viewControllers)
        }
    }
    
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
    /**
     Default morning image for first level view controller
     */
    @objc open var morningLevelOneImage: UIImage? = {
        return UIImage(named: morningLevelOneImageName, in: nil, compatibleWith: nil)
    }()

    /**
     Default morning image for second level view controllers
     */
    @objc open var morningLevelTwoImage: UIImage? = {
        return UIImage(named: morningLevelTwoImageName, in: nil, compatibleWith: nil)
    }()

    /**
     Default evening image for first level view controller
     */
    @objc open var eveningLevelOneImage: UIImage? = {
        return UIImage(named: eveningLevelOneImageName, in: nil, compatibleWith: nil)
    }()

    @objc open var eveningLevelTwoImage: UIImage? = {
        return UIImage(named: eveningLevelTwoImageName, in: nil, compatibleWith: nil)
    }()
    
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
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            nightMode = traitCollection.userInterfaceStyle == .dark
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupDarkMode()
        self.setupBackground()
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
          super.traitCollectionDidChange(previousTraitCollection)
          if #available(iOS 13.0, *) {
              if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                  // do your customization here
                  nightMode = traitCollection.userInterfaceStyle == .dark
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
           return self.nightMode ? self.eveningLevelOneImage : self.morningLevelOneImage
       }

       private func levelTwoDefaultBackgroundImage() -> UIImage? {
           return self.nightMode ? self.eveningLevelTwoImage : self.morningLevelTwoImage
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
