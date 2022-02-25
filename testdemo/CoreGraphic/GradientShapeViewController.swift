//
//  GradientShapeViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/30.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class GradientShapeViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let v = GradientShapeView()
    v.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.addSubview(v)
  }
}

fileprivate final class GradientShapeView: UIView {
  private func radio() {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    
    ctx.setLineWidth(10)
    //使用rgb颜色空间
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    //颜色数组（这里使用三组颜色作为渐变）fc6820
    let compoents:[CGFloat] = [0xfc/255, 0x68/255, 0x20/255, 0,
                               0xfe/255, 0xd3/255, 0x2f/255, 0,
                               0xb1/255, 0xfc/255, 0x33/255, 1]
    //没组颜色所在位置（范围0~1)
    let locations:[CGFloat] = [0,0.5,1]
    //生成渐变色（count参数表示渐变个数）
    let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                              locations: locations, count: locations.count)!
    
    //渐变圆心位置（这里外圆内圆都用同一个圆心）
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    //外圆半径
    let endRadius = min(self.bounds.width, self.bounds.height) / 2
    //内圆半径
    let startRadius = endRadius / 3
    //绘制渐变
    ctx.drawRadialGradient(gradient,
                           startCenter: center, startRadius: startRadius,
                           endCenter: center, endRadius: endRadius,
                           options: .drawsBeforeStartLocation)

  }
  
  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    ctx.addEllipse(in: rect)
    ctx.addEllipse(in: rect.insetBy(dx: -3, dy: -3))
    ctx.setFillColor(UIColor.white.cgColor)
//    //使用rgb颜色空间
//    let colorSpace = CGColorSpaceCreateDeviceRGB()
//    //颜色数组（这里使用三组颜色作为渐变）fc6820
//    let compoents:[CGFloat] = [0xfc/255, 0x68/255, 0x20/255, 1,
//                               0xfe/255, 0xd3/255, 0x2f/255, 1,
//                               0xb1/255, 0xfc/255, 0x33/255, 1]
//    //没组颜色所在位置（范围0~1)
//    let locations:[CGFloat] = [0,0.5,1]
//    //生成渐变色（count参数表示渐变个数）
//    let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
//                              locations: locations, count: locations.count)!
//
//    //渐变开始位置
//    let start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
//    //渐变结束位置
//    let end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
//    //绘制渐变
//    ctx.drawLinearGradient(gradient, start: start, end: end,
//                               options: .drawsBeforeStartLocation)
    
    ctx.fillPath(using: .evenOdd)
  }

}
