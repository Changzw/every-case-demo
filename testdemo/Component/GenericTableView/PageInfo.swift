//
//  PageInfo.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/26.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import Foundation

struct PageInfo {
  private(set) var offset: Int = 0
  private(set) var pageSize: Int
  
  init(pageSize: Int = 50) {
    self.pageSize = pageSize
  }
  
  var isNoMoreData = false
  
  mutating func increase() {
    offset += pageSize
  }
  
  mutating func reset() {
    offset = 0
    isNoMoreData = false
  }
  
  mutating func update(shouldReset: Bool, isNoMoreData: Bool) {
    if shouldReset {
      reset()
    }
    increase()
    self.isNoMoreData = isNoMoreData
  }
}
