//
//  UIFont+extension.swift
//  badamlive
//
//  Created by czw on 9/17/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension UIFont {
  static func UKIJQara(_ size: CGFloat) -> UIFont {
    // 维语字体比汉语 小
    guard let f = UIFont(name: "UKIJQara-Bold", size: size) else {
      return UIFont.systemFont(ofSize: size - 2)
    }
    return f
  }
  
  // roboto 一般数字使用
  static func RobotoMeidum(_ size: CGFloat) -> UIFont {
    guard let f = UIFont(name: "Roboto-Medium", size: size) else {
      return UIFont.systemFont(ofSize: size)
    }
    return f
  }
  
  static func RobotoBlack(_ size: CGFloat) -> UIFont {
    guard let f = UIFont(name: "Roboto-Black", size: size) else {
      return UIFont.systemFont(ofSize: size)
    }
    return f
  }
}

//MARK: - String
extension String {
  /*
   主要是数字
   Roboto Medium
   Roboto-Black
   
   维语
   UKIJ Qara Bold
   */
  
  func ukijQaraFont(_ size: CGFloat) -> UIFont {
    if self.containUyghur() {
      return UIFont.UKIJQara(size)
    }
    
    return UIFont.systemFont(ofSize: size - 2)
  }
}
