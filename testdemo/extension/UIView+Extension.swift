//
//  UIView+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/9/23.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

private var TapClosureKey: Void?
private var PanClosureKey: Void?

extension UIView {
  static func spaceView(height: Float) -> UIView {
    let v = UIView()
    v.snp.makeConstraints{ $0.height.equalTo(height) }
    return v
  }
  static func spaceView(width: Float) -> UIView {
    let v = UIView()
    v.snp.makeConstraints{ $0.width.equalTo(width) }
    return v
  }
}

extension UIView {
  
  typealias TapClosure = (UITapGestureRecognizer) -> Void
  typealias PanClosure = (UIPanGestureRecognizer) -> Void
  
  
  @discardableResult
  static func addBottomPlaceholderView(_ topView: UIView, parentView: UIView, color: UIColor? = nil) -> UIView {
    let placeholderView = UIView()
    if let color = color {
      placeholderView.backgroundColor = color
    } else {
      placeholderView.backgroundColor = topView.backgroundColor
    }
    
    parentView.addSubview(placeholderView)
    placeholderView.snp.makeConstraints { (maker) in
      maker.top.equalTo(topView.snp.bottom)
      maker.leading.trailing.bottom.equalToSuperview()
    }
    return placeholderView
    
  }
  
  @discardableResult
  func addTapGesture(numberOfTapsRequired: Int = 1, closure: TapClosure?) -> UITapGestureRecognizer? {
    isUserInteractionEnabled = true
    objc_setAssociatedObject(self, &TapClosureKey, closure, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    gestureRecognizers?.forEach { gesture in
      if let tapGesture = gesture as? UITapGestureRecognizer {
        removeGestureRecognizer(tapGesture)
      }
    }
    if closure == nil {
      return nil
    }
    let tapGes = UITapGestureRecognizer(target: self, action: #selector(gestureHandler(_:)))
    tapGes.numberOfTapsRequired = numberOfTapsRequired
    addGestureRecognizer(tapGes)
    return tapGes
  }
  
  @discardableResult
  func addPanGesture(_ closure: PanClosure?) -> UIPanGestureRecognizer? {
    isUserInteractionEnabled = true
    objc_setAssociatedObject(self, &PanClosureKey, closure, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    gestureRecognizers?.forEach { gesture in
      if let panGesture = gesture as? UIPanGestureRecognizer {
        removeGestureRecognizer(panGesture)
      }
    }
    if closure == nil {
      return nil
    }
    let panGes = UIPanGestureRecognizer(target: self, action: #selector(gestureHandler(_:)))
    self.addGestureRecognizer(panGes)
    return panGes
  }
  
  @objc private func gestureHandler(_ gesture: UIGestureRecognizer) {
    if let tapGes = gesture as? UITapGestureRecognizer {
      guard let closure = objc_getAssociatedObject(self, &TapClosureKey) as? TapClosure else  { return  }
      closure(tapGes)
    }
    
    if let panGes = gesture as? UIPanGestureRecognizer {
      guard let closure = objc_getAssociatedObject(self, &PanClosureKey) as? PanClosure else  { return  }
      closure(panGes)
    }
  }
  
  static func isRightToLeftLayoutDirection(_ view: UIView? = nil) -> Bool {
    let context: UIView = view ?? UIView.appearance()
    return context.effectiveUserInterfaceLayoutDirection == .rightToLeft
  }
  

  static var safeAreaBottom: CGFloat {
    return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
  }
}

