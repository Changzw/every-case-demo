//
//  UIView+createRoundedRect.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/5.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  struct CornerMask: OptionSet {
    var rawValue: UInt
    static let minXMinYCorner = CornerMask(rawValue: 1)
    static let minXMaxYCorner = CornerMask(rawValue: 2)
    static let maxXMinYCorner = CornerMask(rawValue: 4)
    static let maxXMaxYCorner = CornerMask(rawValue: 8)
  }
  
  func createRoundedRectPath(for rect: CGRect, radius: CGFloat, masks: CornerMask = [.minXMinYCorner, .minXMaxYCorner, .maxXMinYCorner, .maxXMaxYCorner]) -> CGMutablePath {
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
//    if masks.contains(.minXMinYCorner) {
//      
//    }else if masks.contains(.minXMaxYCorner) {
//      
//    }else if masks.contains(.maxXMinYCorner) {
//      
//    }else if masks.contains(.maxXMaxYCorner) {
//      
//    }
    path.addArc(tangent1End: topRightPoint, tangent2End: bottomRightPoint, radius: radius)
    path.addArc(tangent1End: bottomRightPoint, tangent2End: bottomLeftPoint, radius: radius)
    path.addArc(tangent1End: bottomLeftPoint, tangent2End: topLeftPoint, radius: radius)
    path.addArc(tangent1End: topLeftPoint, tangent2End: topRightPoint, radius: radius)
    
    path.closeSubpath()
    
    return path
  }
  
  func roundedCorner() {
    layer.cornerRadius = bounds.maxX / 6
  }
}
