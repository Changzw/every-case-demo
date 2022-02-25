//
//  Then.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit

// 协议还是组合的好，不是每个class读需要那么多的func，有的只需要push，而不需要present,全给虽然方便，but不利用扩展新的protocol！！！

public protocol Then {}

extension Then where Self: Any {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///         $0.textAlignment = .Center
  ///         $0.textColor = UIColor.blackColor()
  ///         $0.text = "Hello, World!"
  ///     }
  @discardableResult
  public func then(block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try block(&copy)
    return copy
  }
  
  /// Makes it available to execute something with closures.
  ///
  ///     UserDefaults.standard.do {
  ///       $0.set("devxoul", forKey: "username")
  ///       $0.set("devxoul@gmail.com", forKey: "email")
  ///       $0.synchronize()
  ///     }
  public func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }
}

public extension Then where Self: AnyObject {
  /// Makes it available to set properties with closures just after initializing.
  ///
  ///     let label = UILabel().then {
  ///         $0.textAlignment = .Center
  ///         $0.textColor = UIColor.blackColor()
  ///         $0.text = "Hello, World!"
  ///     }
  @discardableResult
  func then(block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
  
  @discardableResult
  func then(block: () throws -> Void) rethrows -> Self {
    try block()
    return self
  }
  
  @discardableResult
  func condition(_ condition: () -> Bool,
                 execute: (() -> Void)? = nil,
                 other: (() -> Void)? = nil) -> Self {
    if condition() {
      execute?()
    } else {
      other?()
    }
    return self
  }
}

extension NSObject: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension Optional : Then {}
extension String : Then {}

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}
#endif

public func with<T: Any>(item: T, update: (inout T) throws -> Void) rethrows -> T {
  var this = item; try update(&this); return this
}

public func with<T: AnyObject>(item: T, update: (T) throws -> Void) rethrows -> T {
  try update(item); return item
}

