//
//  Coordinator.swift
//  testdemo
//
//  Created by Fri on 2022/3/28.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    /*Tab, NAV, VC*/
    var rootViewController: UIViewController { get }
    var children: [Coordinator] { get }
    init(rootViewController: UIViewController)
}

class TabCoordinator: Coordinator {
    let rootViewController: UIViewController
    private var tabController: UITabBarController {
        rootViewController as! UITabBarController
    }
    
    var children: [Coordinator] = [] {
        didSet {
            tabController.setViewControllers(children.map(\.rootViewController), animated: true)
        }
    }
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

class NavigationCoordinator: Coordinator {
    let rootViewController: UIViewController
    private var navigationController: UINavigationController {
        rootViewController as! UINavigationController
    }

    var children: [Coordinator] = [] {
        didSet {
            self.navigationController.setViewControllers(children.map(\.rootViewController), animated: true)
        }
    }
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

class ViewCoordinator: Coordinator {
    let rootViewController: UIViewController
    
    var children: [Coordinator] = [] {
        didSet {
            
        }
    }
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}
