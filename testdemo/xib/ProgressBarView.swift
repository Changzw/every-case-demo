//
//  ProgressBarView.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/20.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressBarView: UIView {
  
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
