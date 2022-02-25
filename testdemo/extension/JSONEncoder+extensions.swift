//
//  JSONEncoder+extensions.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/12/5.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

extension JSONEncoder {
  func jsonString<T: Codable>(of obj: T, encoding: String.Encoding = .utf8) -> String? {
    guard let jsonData = try? JSONEncoder().encode(obj),
          let string = String(data: jsonData, encoding: encoding) else { return nil }
    return string
  }
}
