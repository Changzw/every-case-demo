//
//  GradientButton.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/5.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientButton: UIButton {

  override class var layerClass: AnyClass { CAGradientLayer.self }
  private var _layer: CAGradientLayer { layer as! CAGradientLayer }
  
  @IBInspectable
  var startColor: UIColor = .red {
    didSet {
      _layer.colors = [startColor, endColor].map{ $0.cgColor }
      setNeedsDisplay()
    }
  }
  
  @IBInspectable
  var endColor: UIColor = .green {
    didSet {
      _layer.colors = [startColor, endColor].map{ $0.cgColor }
      setNeedsDisplay()
    }
  }
  
  @IBInspectable
  var startPoint: CGPoint = .zero {
    didSet {
      _layer.startPoint = startPoint
      setNeedsDisplay()
    }
  }
  
  @IBInspectable
  var endPoint: CGPoint = CGPoint(x: 1, y: 0) {
    didSet {
      _layer.endPoint = endPoint
      setNeedsDisplay()
    }
  }
}
