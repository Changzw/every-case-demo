//
//  Array+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/11/2.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

extension Array {
  public func safeObject(at index: Int) -> Element? {
    if (0..<count).contains(index) {
      return self[index]
    } else {
      return nil
    }
  }
}
