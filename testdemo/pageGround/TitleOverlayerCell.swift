//
//  TitleOverlayerView.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/7.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class TitleOverlayerView: UIView {
  var height: CGFloat = 44 {
    didSet {
      addConstraints()
    }
  }
  
  var contentBackgroundColor: UIColor? {
    set {
      contentView.backgroundColor = newValue
    }
    get {
      return contentView.backgroundColor
    }
  }
  
  private let contentView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addConstraints()
    contentBackgroundColor = UIColor.white.withAlphaComponent(0.9)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addConstraints()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    contentView.layer.cornerRadius = contentView.bounds.height / 2
  }
  
  private func addConstraints() {
    addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let trailingConstraint = NSLayoutConstraint(
      item: self,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: contentView,
      attribute: .trailing,
      multiplier: 1,
      constant: 0)
    let leadingConstraint = NSLayoutConstraint(
      item: contentView,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1,
      constant: 0)
    let centerConstraint = NSLayoutConstraint(
      item: self,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: contentView,
      attribute: .centerY,
      multiplier: 1,
      constant: 0)
    let hightConstraint = NSLayoutConstraint(
      item: contentView,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .height,
      multiplier: 1,
      constant: height)
    
    addConstraints([centerConstraint, trailingConstraint, leadingConstraint])
    contentView.addConstraint(hightConstraint)
  }
}
