//
//  UIImage+extension.swift
//  badamlive
//
//  Created by adi on 2020/10/21.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension UIImage {

  class func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
      UIGraphicsBeginImageContext(size)
      let context = UIGraphicsGetCurrentContext()
      context!.setFillColor(color.cgColor);
      context!.fill(CGRect(origin: CGPoint.zero, size: size))
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image!
  }
  
  func alpha(_ value:CGFloat) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
