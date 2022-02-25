//
//  HoleView.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/19.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class HoleView: UIView {
  
  var fillColor: UIColor = UIColor.black.withAlphaComponent(0.65) {
    didSet {
      
    }
  }
  
  var holeFrame: CGRect = .zero {
    didSet {
      layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
      guard holeFrame != .zero else { return }
      
      let path = UIBezierPath(rect: bounds)
      let holePath = UIBezierPath(rect: holeFrame)
      
      path.append(holePath)
      let holeLayer = CAShapeLayer()
      holeLayer.frame = bounds
      holeLayer.fillColor = fillColor.cgColor
      holeLayer.fillRule = CAShapeLayerFillRule.evenOdd
      holeLayer.path = path.cgPath
      layer.addSublayer(holeLayer)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .clear
  }
}
