//
//  NSAttributedString+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/12/11.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

extension NSAttributedString {
  
  func showAttributedStringLink() -> NSAttributedString {
    let mutableAttributedString: NSMutableAttributedString
    if let attributedString = self as? NSMutableAttributedString {
      mutableAttributedString = attributedString
    } else {
      mutableAttributedString = NSMutableAttributedString(attributedString: self)
    }
    mutableAttributedString.addLinkAttributed()
    return mutableAttributedString
  }
  
}
