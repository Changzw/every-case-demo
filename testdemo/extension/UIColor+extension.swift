//
//  UIColor+extension.swift
//  badamlive
//
//  Created by czw on 9/15/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension UIColor {

  static var random: UIColor {
    UIColor(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 0.9)
  }
}
