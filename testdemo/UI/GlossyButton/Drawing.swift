//
//  Drawing.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/5.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit

func drawLinearGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
  // 1
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  
  // 2
  let colorLocations: [CGFloat] = [0.0, 1.0]
  
  // 3
  let colors: CFArray = [startColor, endColor] as CFArray
  
  // 4
  let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
  
  // 5
  let startPoint = CGPoint(x: rect.midX, y: rect.minY)
  let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
  
  context.saveGState()
  // 6
  context.addRect(rect)
  // 7
  context.clip()
  // 8
  context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
  context.restoreGState()

  // More to come...
}

func drawGlossAndGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
  // 1
  drawLinearGradient(context: context, rect: rect, startColor: startColor, endColor: endColor)
  let glossColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35)
  let glossColor2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
  let topHalf = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height/2))
  
  drawLinearGradient(context: context,
                     rect: topHalf,
                     startColor: glossColor1.cgColor,
                     endColor: glossColor2.cgColor)
}
