//
//  CornerShadowView.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/20.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
@IBDesignable
class CornerShadowView: UIView {
  
  @IBInspectable
  public var topLeft: Bool = false{
    didSet{ redraw() }
  }
  
  @IBInspectable
  public var bottomLeft: Bool = false{
    didSet{ redraw() }
  }
  
  @IBInspectable
  public var topRight: Bool = false{
    didSet{ redraw() }
  }
  
  @IBInspectable
  public var bottomRight: Bool = false{
    didSet{ redraw() }
  }
  
  @IBInspectable
  public var cornerPosition: UIRectCorner = [.allCorners] {
    didSet{ redraw() }
  }

  @IBInspectable
  public var cornerRadius: CGFloat = 10{
    didSet{ redraw() }
  }
  @IBInspectable
  public var shadowOffset: CGSize = .zero{
    didSet{ redraw() }
  }
  @IBInspectable
  public var shadowRadius: CGFloat = 0{
    didSet{ redraw() }
  }
  @IBInspectable
  public var shadowColor: UIColor = .black{
    didSet{ redraw() }
  }
  @IBInspectable
  public var fillColor: UIColor = .white{
    didSet{ redraw() }
  }
  public var margins: UIEdgeInsets = .zero{
    didSet{ redraw() }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    var corners: UIRectCorner = []
    if topLeft {
      corners.insert(.topLeft)
    }
    if bottomLeft {
      corners.insert(.bottomLeft)
    }
    if topRight {
      corners.insert(.topRight)
    }
    if bottomRight {
      corners.insert(.bottomRight)
    }
    
    if shadowRadius > 0 {
      let shadowPath = UIBezierPath(roundedRect: rect.inset(by: margins), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
      let context = UIGraphicsGetCurrentContext()
      context?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)
      fillColor.setFill()
      shadowPath.fill()
    }
    
    let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.path = maskPath.cgPath
    maskLayer.frame = rect
    layer.mask = maskLayer
  }
  
  // MARK: - lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  // MARK: - private method
  fileprivate func redraw(){
    setNeedsDisplay()
    if shadowRadius > 0 {
      backgroundColor = UIColor.clear
    }
  }
}
