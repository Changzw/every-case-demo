//
//  GradientCircleView.swift
//  badamlive
//
//  Created by 常仲伟 on 2021/4/12.
//  Copyright © 2021 czw. All rights reserved.
//

import UIKit

struct GradientCircleParams {
  var colors: [UIColor]?
  var locations: [CGFloat]?
  var startPoint: CGPoint = .zero
  var endPoint: CGPoint = CGPoint(x: 0, y: 1)
  
  var trackFillColor: UIColor?
  var traceStrokeColor: UIColor?
  var lineWidth: CGFloat = 2
  var lineCap: CAShapeLayerLineCap? = .round
  var lineJoin: CAShapeLayerLineJoin? = .round
  
  var startAngle: Double = 0
  var endAngle: Double = 0
}

final class GradientCircleView: UIView {
  var params = GradientCircleParams() {
    didSet {
      updateLayer()
    }
  }
  
  private let circleProcessLayer  = CAShapeLayer()
  private let trackLayer          = CAShapeLayer()
  private let gradientLayer       = CAGradientLayer()
  
  private var timer: DispatchSourceTimer?
  var step: Double = 0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateLayer()
  }
  //  override func awakeFromNib() {
  //    super.awakeFromNib()
  //    setUI()
  //    strokeEndFloat = 0
  //    timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
  //    timer?.setEventHandler { [weak self] in
  //      guard let self = self else { return }
  //      self.step += 0.1
  //      self.strokeEndFloat = CGFloat(self.step)
  //      self.updateLayer()
  //    }
  //    timer?.schedule(deadline: .now() + .seconds(1), repeating: .seconds(1))
  //    timer?.activate()
  //  }
  
//  func setUI() {
//    layer.addSublayer(trackLayer)
//    gradientLayer = CAGradientLayer()
//    gradientLayer.frame  = CGRect(x: 0, y: 0, width: 240, height: 240)
//    gradientLayer.colors = colors1
//    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//    gradientLayer.endPoint   = CGPoint(x: 0, y: 1)
//    layer.addSublayer(gradientLayer)
//
//    // 创建一个圆形layer
//    circleProcessLayer = CAShapeLayer()
//    //    circleProcessLayer.frame = bounds
//    circleProcessLayer.path = UIBezierPath(arcCenter: CGPoint(x: 120, y: 120),
//                                    radius: 100,
//                                    startAngle: CGFloat(Double.pi/30),
//                                    endAngle: 2 * CGFloat(Double.pi) - CGFloat(Double.pi/30),
//                                    clockwise: true).cgPath
//    circleProcessLayer.lineWidth    = 5
//    circleProcessLayer.lineCap      = .round
//    circleProcessLayer.lineJoin     = .round
//    circleProcessLayer.strokeColor  = UIColor.black.cgColor
//    circleProcessLayer.fillColor    = UIColor.clear.cgColor
//
//    trackLayer.path = circleProcessLayer.path
//    layer.mask = circleProcessLayer
//  }
  
  func updateLayer() {
    if gradientLayer.superlayer == nil {
      layer.addSublayer(gradientLayer)
    }
    if trackLayer.superlayer == nil {
      layer.addSublayer(trackLayer)
    }
    if circleProcessLayer.superlayer == nil {
      layer.addSublayer(circleProcessLayer)
    }
    gradientLayer.frame       = bounds
    gradientLayer.colors      = params.colors?.map(\.cgColor)
    gradientLayer.startPoint  = params.startPoint
    gradientLayer.endPoint    = params.endPoint
    
    trackLayer.fillColor      = params.trackFillColor?.cgColor
    trackLayer.strokeColor    = params.traceStrokeColor?.cgColor

    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let raduis = (frame.size.width - params.lineWidth) / 2
    
//    circleProcessLayer.path = UIBezierPath(arcCenter: CGPoint(x: 120, y: 120),
//                                           radius: 100,
//                                           startAngle: CGFloat(Double.pi/30),
//                                           endAngle: 2 * CGFloat(Double.pi) - CGFloat(Double.pi/30),
//                                           clockwise: true).cgPath
    circleProcessLayer.lineWidth    = 5
    circleProcessLayer.lineCap      = .round
    circleProcessLayer.lineJoin     = .round
    circleProcessLayer.strokeColor  = UIColor.black.cgColor
    circleProcessLayer.fillColor    = UIColor.clear.cgColor
    
//    trackLayer.path = UIBezierPath(arcCenter: center,
//                                   radius: raduis,
//                                   startAngle: 0,
//                                   endAngle: 2 * Double.pi,
//                                   clockwise: true).cgPath
    

//    let path = UIBezierPath(arcCenter: center,
//                            radius: raduis,
//                            startAngle: params.startAngle,
//                            endAngle: params.endAngle,
//                            clockwise: false)
//
//    let center = CGPoint(x: bounds.midX, y: bounds.midY)
//    let raduis = (frame.size.width - lineWidth) / 2
//    let path = UIBezierPath(arcCenter: center,
//                            radius: raduis,
//                            startAngle: startAngle,
//                            endAngle: endAngle,
//                            clockwise: false)
//    path.lineCapStyle = lineCap
//    circleProcessLayer.path = path.cgPath
  }
//  private(set) lazy var trackLayer: CAShapeLayer = {
//    let l = CAShapeLayer()
//    l.strokeStart = 0
//    l.strokeEnd = 1
//    l.fillColor = UIColor.black.cgColor
//    l.strokeColor = UIColor.black.cgColor
//    l.lineWidth = 5
//    l.lineCap = .round
//    return l
//  }()

//  @IBInspectable
//  public var lineWidth: CGFloat = 5.0 {
//    didSet {
//      circleProcessLayer.lineWidth = lineWidth
//      updateLayer()
//    }
//  }
//
//  @IBInspectable
//  public var strokeColor: UIColor = .red {
//    didSet {
//      circleProcessLayer.strokeColor = strokeColor.cgColor
//      setNeedsDisplay()
//    }
//  }
//
//  @IBInspectable
//  public var fillColor: UIColor = .clear {
//    didSet {
//      circleProcessLayer.fillColor = fillColor.cgColor
//      setNeedsDisplay()
//    }
//  }
//
//  public var lineCap: CGLineCap = .round {
//    didSet {
//      updateLayer()
//    }
//  }
//
//  @IBInspectable
//  public var startAngle: CGFloat = .pi * 1.5 {
//    didSet {
//      updateLayer()
//    }
//  }
//
//  @IBInspectable
//  public var endAngle: CGFloat = -.pi * 0.5 {
//    didSet {
//      updateLayer()
//    }
//  }
  

//  var colors1: [CGColor] = [UIColor(red: 137.0/255.0, green: 137.0/255.0, blue: 137.0/255.0, alpha: 1).cgColor,
//                           UIColor.orange.cgColor]
  
//  var strokeEndFloat:CGFloat = 0 {
//    didSet {
//      circleProcessLayer.strokeEnd = strokeEndFloat
//    }
//  }
  

  func startLoading() {
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.toValue  =  2 * Double.pi
    animation.duration = 1.25
    animation.repeatCount = HUGE
    layer.add(animation, forKey: "")
  }
}
