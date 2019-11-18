//
//  Coordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/11/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit
protocol Coordinator: class {
    // coordinator has one or more child coordinator you can let that we will have
    var childCoordinators: [Coordinator] { get set }
    ///coordinator uses router for navigation to perform transitions and presentation
    var router: Router { get }
    /// use this method to present coordinator VC
    func present(animated: Bool,
                 onCompletion: NavigationClosure?,
                 onDismissed: NavigationClosure?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator,
                      animated: Bool,
                      onCompletion: NavigationClosure?,
                      onDismissed: NavigationClosure?)
    init(navigationRouter: Router)
}
// default implementation for dismiss and present child 
extension Coordinator {
    func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
    
    func presentChild(_ child: Coordinator,animated: Bool, onCompletion: NavigationClosure?, onDismissed: (() -> Void)? = nil) {
        childCoordinators.append(child)
        child.present(animated: animated, onCompletion: onCompletion, onDismissed:{[weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        })
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child })
            else { return
        }
        childCoordinators.remove(at: index)
    }
}

/// for abstaction we will make all viewcontroller to conform on storyboarded protocol and implement instantiate
protocol Storyboarded {
      /// coordinator delegate
      var coordinatorDelegate: Coordinator? { get set }
      /// storyBoard name
      static var storyBoarName: String { get }
      /// expected to return the instance self when being implemented
      static func instantiate(delegate: Coordinator?) -> Self?
}
extension Storyboarded where Self: UIViewController {
    /// assume that  we have the main  story board  only
    static var storyBoarName: String { return "Main" }
    static func instantiate(delegate: Coordinator?) -> Self? {
        /// get the full ViewController name = MyApp.MyViewController
        let fullVcName = NSStringFromClass(self)
        guard fullVcName.contains(".") else {
            return nil
        }
        let vcName = fullVcName.components(separatedBy: ".")[1]
        let storyBoard = UIStoryboard(name: storyBoarName , bundle: nil)
        
        var viewControllerInstance = storyBoard.instantiateViewController(withIdentifier: vcName) as? Self
        viewControllerInstance?.coordinatorDelegate = delegate
        return viewControllerInstance
    }
}
