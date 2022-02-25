//
//  File.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/23.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation

open class SensorsAnalyticsSDK : NSObject {
  static let share = SensorsAnalyticsSDK()
  open func track(_ event: String, withProperties propertyDict: [AnyHashable : Any]?){}
}

/*
 1. 埋点是要分业务模块的
 2. name
 3. propertyDict, 要以变量的放是穿进去
 
 * 设计要注意的点，多业务模块化
 * 擦除名字
 * 收集所有属性的接口——这个就封装到模块中
 */

protocol Event {
  var name: String {get}
  var params: [String: Any] {get}
  func track()
}

extension Event {
  func track() {
    SensorsAnalyticsSDK.share.track(name, withProperties: params)
  }
}

struct UserEvent: Event {
  let name: String
  let params: [String : Any]
}

extension UserEvent {
  enum Room{}
}

extension UserEvent.Room {
  static func clickCell(id: String, index: Int, name: String) -> UserEvent {
    return UserEvent(name: "clickCell", params: [
      "index": index,
      "id": id,
      "name": name,
    ])
  }
}

func testEnvet() {
  UserEvent.Room.clickCell(id: "11", index: 11, name: "name").track()
}

// 如果testEnvet 调用方式不好看，那么再加一层
struct UserEventManager {
  func track(event: Event) {
    event.track()
  }
}
