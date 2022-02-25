//
//  UIAlertController+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/10/10.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension UIAlertController {
  
  /// UIAlertController的便利构造方法
  ///
  /// - Parameters:
  ///   - title: alert标题
  ///   - message: alert内容
  ///   - cancelTitle: 取消按钮标题，不可为空
  ///   - otherTitles: 其他按钮的标题，可以为空
  ///   - context: 负责 present  的 controller
  ///   - handler: 点击事件回调，取消按钮不可为空，闭包的第二个参数是按钮的下标，取消按钮的下标恒为0，其他按钮的下标为otherTitles数组对应的元素下标+1
  @discardableResult
  convenience init?(title: String,
                    message: String,
                    cancelTitle: String,
                    otherTitles: [String] = [],
                    context: UIViewController?,
                    handler: ((UIAlertController, Int) -> Void)? = nil) {
    guard let context = context else { return nil }
    self.init(title:title, message: message, preferredStyle: .alert)
    
    self.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { [weak self] (action) -> Void in
      guard let strongSelf = self else { return }
      handler?(strongSelf, 0)
    }))
    
    
    for i in  0..<otherTitles.count {
      let t = otherTitles[i]
      
      self.addAction(UIAlertAction(title: t, style: .default, handler: { [weak self] (action) -> Void in
        guard let strongSelf = self else { return }
        handler?(strongSelf, i + 1)
      }))
    }
    context.present(self, animated: true, completion: nil)
  }
}
