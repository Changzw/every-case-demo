//
//  Array+Layout.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/10/4.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element == NSLayoutConstraint.Attribute {
  func anchor(from fromView: UIView, to toView: UIView) -> [NSLayoutConstraint] {
    return map {
      NSLayoutConstraint(
        item: fromView,
        attribute: $0,
        relatedBy: .equal,
        toItem: toView,
        attribute: $0,
        multiplier: 1,
        constant: 0
      )
    }
  }
}
