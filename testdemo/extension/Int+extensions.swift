//
//  Int+extensions.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/12/10.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

extension Int {
  private var sureTwo: String {
    self >= 10 ? String(self) : ("0" + String(self))
  }
  
  var hhmmss: String {
    let h = self / 3600
    let other = self % 3600
    let m = other / 60
    let s = other % 60
    
    let hh = h.sureTwo
    let mm = m.sureTwo
    let ss = s.sureTwo
    
    return hh + ":" + mm + ":" + ss
  }
  
  var hhmm: String {
    let h = self / 3600
    let other = self % 3600
    let m = other / 60
    
    let hh = h.sureTwo
    let mm = m.sureTwo
    
    return hh + ":" + mm
  }
  
  var mmss: String {
    let m = self / 60
    let s = self % 60
    
    let mm = m.sureTwo
    let ss = s.sureTwo
    
    return mm + ":" + ss
  }
  
  var hh: String {
    let h = self / 3600
    let hh = h.sureTwo

    return hh
  }
  
  var mm: String {
    let m = self / 60
    let mm = m.sureTwo
    
    return mm
  }
  
  var ss: String {
    let s = self % 60
    let ss = s.sureTwo
    
    return ss
  }
}

extension Int {
  subscript(digitIndex: Int) -> Int {
    var decimalBase = 1
    for _ in 0..<digitIndex {
      decimalBase *= 10
    }
    return (self / decimalBase) % 10
  }
  
  var random: Int {
    Int(arc4random()) % self
  }
}
