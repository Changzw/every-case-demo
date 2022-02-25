//
//  CoolButton.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
/*
 制作圆角矩形的一种方法是使用 CGContextAddArc API 绘制弧线。
 使用该 API，您可以在每个角处绘制弧线并绘制线以连接它们。
 但这很麻烦，并且需要大量的几何图形。
 幸运的是，有一个更简单的方法！您不必做太多的数学运算，它适用于绘制圆角矩形。
 它是 CGContextAddArcToPoint API。
 CGContextAddArcToPoint API 允许您通过指定两条切线和一个半径来描述要绘制的弧线。 Quartz2D 编程指南中的下图显示了它是如何工作的：
 https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadows/dq_shadows.html#//apple_ref/doc/uid/TP30001066-CH208-SW1
 */
final class CoolButton: UIButton {
  var hue: CGFloat = 0.0 {//色调
    didSet {
      setNeedsDisplay()
    }
  }
  
  var saturation: CGFloat {//饱和
    didSet {
      setNeedsDisplay()
    }
  }
  
  var brightness: CGFloat {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    self.hue = 0.5
    self.saturation = 0.5
    self.brightness = 0.5
    super.init(frame: frame)
    
    isOpaque = false
    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.hue = 0.5
    self.saturation = 0.5
    self.brightness = 0.5
    
    super.init(coder: aDecoder)
    
    self.isOpaque = false
    self.backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    
    // 1
    let outerColor = UIColor(
      hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    let shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    
    // 2
    let outerMargin: CGFloat = 5.0
    let outerRect = rect.insetBy(dx: outerMargin, dy: outerMargin)
    // 3
    let outerPath = createRoundedRectPath(for: outerRect, radius: 6.0)
    
    // 4
    if state != .highlighted {
      context.saveGState()
      context.setFillColor(outerColor.cgColor)
      context.setShadow(offset: CGSize(width: 0, height: 2),
                        blur: 3.0, color: shadowColor.cgColor)
      context.addPath(outerPath)
      context.fillPath()
      context.restoreGState()
    }
  }
}

