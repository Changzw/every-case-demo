//
//  WaitingProgressView.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/12/14.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

final class WaitingProgressView: UIView {
  var progress: CGFloat = 0.0 {
    didSet {
      progressLayer.strokeEnd = progress
    }
  }
  
  private lazy var progressLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    
    shapeLayer.path = UIBezierPath(arcCenter: center,
                                   radius: center.x,
                                   startAngle: CGFloat(Double.pi / 2 * 3),
                                   endAngle: CGFloat(Double.pi / 2 * 3 + Double.pi * 2),
                                   clockwise: true).cgPath
    shapeLayer.strokeStart = 0
    shapeLayer.strokeEnd = 0
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = UIColor.red.cgColor
    shapeLayer.lineWidth = 4.5
    
    return shapeLayer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.addSublayer(progressLayer)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    progressLayer.frame = bounds
  }
}

