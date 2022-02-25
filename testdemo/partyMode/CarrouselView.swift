//
//  CarrouselView.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/8/16.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class CarrouselView: UIView {
  var text: String? = "" {
    didSet {
      guard bounds != .zero else {return}
      guard text != nil else { stop(); return }
      guard text != oldValue else {return}
      visibleItems.forEach{
        $0.removeFromSuperview()
      }
      [textLabel]
        .forEach{
          $0.text = text
          $0.sizeToFit()
        }
      visibleItems = [textLabel]
      
      let width = bounds.width
      let contentWidth = textLabel.bounds.width * 2
      if contentWidth < width {
        space = width - contentWidth + 5
      }
      
      textLabel.center.x = bounds.midX//CGPoint(x: bounds.midX, y: bounds.midY)
      start()
    }
  }
  
  private var space: CGFloat = 10
  private var displayLink: CADisplayLink?
  private var perFrameOffset: CGFloat = 0.5
  
  private lazy var visibleItems: [UIView] = []
  private lazy var recycleItems: [UIView] = []
  
  private(set) lazy var textLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.UKIJQara(9)
    l.textColor = .red
    return l
  }()
  
  private var copyItem: UILabel {
    let l = UILabel()
    l.font = textLabel.font
    l.textColor = textLabel.textColor
    l.text = textLabel.text
    l.sizeToFit()
    return l
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(textLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func start() {
    displayLink?.invalidate()
    displayLink = CADisplayLink(target: self, selector: #selector(update))
    displayLink?.add(to: .main, forMode: .common)
  }
  
  func stop() {
    displayLink?.invalidate()
  }
  
  @objc private func update() {
    visibleItems.forEach{
      let f0 = $0.frame
      $0.frame = CGRect(x: f0.minX+perFrameOffset, y: f0.minY, width: f0.width, height: f0.height)
    }
    
    if let first = visibleItems.first, !first.frame.intersects(bounds) {
      recycleItems.append(visibleItems.removeFirst())
    }
    
    if let last = visibleItems.last, last.frame.minX > space {
      let item = recycleItems.count > 0 ? recycleItems.removeFirst() : copyItem
      let f = item.frame
      item.frame = CGRect(x: -f.width, y: f.minY, width: f.width, height: f.height)
      visibleItems.append(item)
    }
  }
}
