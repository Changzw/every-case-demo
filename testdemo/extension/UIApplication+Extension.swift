//
//  UIApplication+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/10/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension UIApplication {
  
  static func currentTabBarController() -> UITabBarController? {
    return UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
  }
  
  static func currentNavigationController() -> UINavigationController? {
    if let tabBarC = currentTabBarController(),
       let navC = tabBarC.selectedViewController as? UINavigationController {
      return navC
    }
    if let navC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      return navC
    }
    return nil
  }
  
  static func currentController() -> UIViewController? {
    return currentNavigationController()?.topViewController
  }
}
