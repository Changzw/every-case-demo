//
//  UIButton+extension.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/10/19.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit
import Nuke

extension UIButton {
  func flipHorizental() {
    imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
    transform = CGAffineTransform(scaleX: -1, y: 1)
  }
}

extension UIButton: Nuke_ImageDisplaying {
  public func nuke_display(image: UIImage?) {
    setImage(image, for: .normal)
  }
}

final class RoundedButton: UIButton {
  var radius: CGFloat?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let r = radius, r == 0 else {
      layer.cornerRadius = bounds.height / 2
      return
    }
  }
}
