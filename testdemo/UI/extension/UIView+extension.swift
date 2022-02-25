//
//  UIView+extension.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/25.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit
 
extension UIView {
  func createRoundedRectPath(for rect: CGRect, radius: CGFloat) -> CGMutablePath {
    let path = CGMutablePath()
    
    // 1
    let midTopPoint = CGPoint(x: rect.midX, y: rect.minY)
    path.move(to: midTopPoint)
    
    // 2
    let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
    let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
    
    // 3
    path.addArc(tangent1End: topRightPoint, tangent2End: bottomRightPoint, radius: radius)
    path.addArc(tangent1End: bottomRightPoint, tangent2End: bottomLeftPoint, radius: radius)
    path.addArc(tangent1End: bottomLeftPoint, tangent2End: topLeftPoint, radius: radius)
    path.addArc(tangent1End: topLeftPoint, tangent2End: topRightPoint, radius: radius)

    path.closeSubpath()
    
    return path
  }
  
  func roundCorner() {
    layer.cornerRadius = bounds.maxX / 6
  }
}
