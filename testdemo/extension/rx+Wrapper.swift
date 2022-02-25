//
//  rx+Wrapper.swift
//  badamlive
//
//  Created by 常仲伟 on 2021/8/25.
//  Copyright © 2021 czw. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

@propertyWrapper
struct BehaviorRelayed<T> {
  var wrappedValue: T {
    get { relay.value }
    set { relay.accept(newValue) }
  }
  var projectedValue: BehaviorRelay<T> { relay }
  private let relay: BehaviorRelay<T>
  
  init(wrappedValue: @autoclosure () -> T) {
    relay = .init(value: wrappedValue())
  }
}
