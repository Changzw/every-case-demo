//
//  CoolButton.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
/*
 https://www.raywenderlich.com/216251-core-graphics-how-to-make-a-glossy-button
 制作圆角矩形的一种方法是使用 CGContextAddArc API 绘制弧线。
 使用该 API，您可以在每个角处绘制弧线并绘制线以连接它们。
 但这很麻烦，并且需要大量的几何图形。
 幸运的是，有一个更简单的方法！您不必做太多的数学运算，它适用于绘制圆角矩形。
 它是 CGContextAddArcToPoint API。
 CGContextAddArcToPoint API 允许您通过指定两条切线和一个半径来描述要绘制的弧线。 Quartz2D 编程指南中的下图显示了它是如何工作的：
 https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadows/dq_shadows.html#//apple_ref/doc/uid/TP30001066-CH208-SW1
 
 When the properties are set, you trigger a call to setNeedsDisplay to
 force your UIButton to redraw the button when the user changes its color.
 */
final class CoolButton: UIButton {
  var hue: CGFloat {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var saturation: CGFloat {
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
    self.isOpaque = false
    self.backgroundColor = .clear
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
    
    var actualBrightness = brightness
    
    if state == .highlighted {
      actualBrightness -= 0.1
    }
    
    let outerColor = UIColor(hue: hue, saturation: saturation, brightness: actualBrightness, alpha: 1.0)
    let shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    
    let outerMargin: CGFloat = 5.0
    let outerRect = rect.insetBy(dx: outerMargin, dy: outerMargin)
    let outerPath = createRoundedRectPath(for: outerRect, radius: 6.0)
    
    if state != .highlighted {
      context.saveGState()
      context.setFillColor(outerColor.cgColor)
      context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3.0, color: shadowColor.cgColor)
      context.addPath(outerPath)
      context.fillPath()
      context.restoreGState()
    }
    
    // Outer Path Gloss & Gradient
    let outerTop = UIColor(hue: hue, saturation: saturation, brightness: actualBrightness, alpha: 1.0)
    let outerBottom = UIColor(hue: hue, saturation: saturation, brightness: actualBrightness * 0.8, alpha: 1.0)
    
    context.saveGState()
    context.addPath(outerPath)
    context.clip()
    drawGlossAndGradient(context: context, rect: outerRect, startColor: outerTop.cgColor, endColor: outerBottom.cgColor)
    context.restoreGState()
    
    // Inner Path Gloss & Gradient
    let innerTop = UIColor(hue: hue, saturation: saturation, brightness: actualBrightness * 0.9, alpha: 1.0)
    let innerBottom = UIColor(hue: hue, saturation: saturation, brightness: actualBrightness * 0.7, alpha: 1.0)
    
    let innerMargin: CGFloat = 3.0
    let innerRect = outerRect.insetBy(dx: innerMargin, dy: innerMargin)
    let innerPath = createRoundedRectPath(for: innerRect, radius: 6.0)
    
    context.saveGState()
    context.addPath(innerPath)
    context.clip()
    drawGlossAndGradient(context: context, rect: innerRect, startColor: innerTop.cgColor, endColor: innerBottom.cgColor)
    context.restoreGState()
  }
  
  @objc func hesitateUpdate() {
    setNeedsDisplay()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    setNeedsDisplay()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    setNeedsDisplay()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    setNeedsDisplay()
    
    perform(#selector(hesitateUpdate), with: nil, afterDelay: 0.1)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    setNeedsDisplay()
    
    perform(#selector(hesitateUpdate), with: nil, afterDelay: 0.1)
  }
}
