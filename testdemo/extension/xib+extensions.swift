//
//  xib+extensions.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/12/22.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation
import UIKit

protocol XibLoadable {
  static func loadFromNib() -> Self
}

extension UIView: XibLoadable {
  static func loadFromNib() -> Self {
    let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
    if let view = nib.instantiate(withOwner: Self.self, options: nil).first as? Self {
      return view
    }
    
    fatalError("Could not load view with type:" + String(describing: Self.self))
  }
}

extension UIViewController: XibLoadable {
  static func loadFromNib() -> Self {
    Self.init(nibName: String(describing: Self.self), bundle: nil)
  }
}

extension Bundle {
  static func loadView<T>(withType type: T.Type, fromNib name: String = String(describing: T.self)) -> T where T: AnyObject {
    if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
      return view
    }
    
    fatalError("Could not load view with type:" + String(describing: type))
  }
}
