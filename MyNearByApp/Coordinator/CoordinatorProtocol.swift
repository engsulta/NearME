//
//  Coordinator.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 11/11/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    // coordinator has one or more child coordinator you can let that we will have coordinator for each screen
    var childCoordinators: [Coordinator] { get set }
    ///coordinator uses navigation controller to perform its role in navigation
    var navigationController: UINavigationController { get set }
    
    func start()
}

/// for abstaction we will make all viewcontroller to conform on storyboarded protocol and implement instantiate
protocol Storyboarded {
    /// storyBoard name
    static var storyBoarName: String { get }
    /// expected to return the instance self when being implemented
    static func instantiate() -> Self?
    var coordinatorDelegate: Coordinator? { get }
}
extension Storyboarded where Self: UIViewController{
    /// assume that  we have the main  story board  only
    static var storyBoarName: String { return "Main" }
    static func instantiate() -> Self? {
        /// get the full ViewController name = MyApp.MyViewController
        let fullVcName = NSStringFromClass(self)
        guard fullVcName.contains(".") else {
            return nil
        }
        let vcName = fullVcName.components(separatedBy: ".")[1]
        let storyBoard = UIStoryboard(name: storyBoarName , bundle: nil)
        
        return storyBoard.instantiateViewController(withIdentifier: vcName) as? Self
    }
}
