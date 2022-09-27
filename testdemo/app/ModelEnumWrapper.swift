//
//  ModelEnumWrapper.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/14.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation

@propertyWrapper
struct ModelEnumWrapper<T: Codable>: Codable {
  var wrappedValue: T?
  init(wrappedValue: T?) {
    self.wrappedValue = wrappedValue
  }
  
  init(from decoder: Decoder) throws {
    let c = try? decoder.singleValueContainer()
    wrappedValue = try? c?.decode(T.self)
  }
}
extension ModelEnumWrapper: Equatable where T: Equatable {}
extension ModelEnumWrapper: Hashable where T: Hashable{}

protocol SingleValueDecodable: Decodable, RawRepresentable, Equatable {}

extension SingleValueDecodable where RawValue: Decodable {
  init(from decoder: Decoder) throws {
    let c = try decoder.singleValueContainer()
    let rv = try c.decode(RawValue.self)
    self.init(rawValue: rv)!
  }
}

@propertyWrapper
public struct LossyArray<T: Codable>: Codable {
  private struct AnyDecodableValue: Codable {}
  
  public var wrappedValue: [T?]?
  
  public init(wrappedValue: [T?]?) {
    self.wrappedValue = wrappedValue
  }
  
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    
    var elements: [T] = []
    while !container.isAtEnd {
      do {
        let value = try container.decode(T.self)
        elements.append(value)
      } catch {
        _ = try? container.decode(AnyDecodableValue.self)
      }
    }
    
    self.wrappedValue = elements
  }
  
  public func encode(to encoder: Encoder) throws {
    try wrappedValue.encode(to: encoder)
  }
}

extension LossyArray: Equatable where T: Equatable { }
extension LossyArray: Hashable where T: Hashable { }

enum NobleLevelEnum: Int, Codable, Equatable {
  case level1 = 1 // 贵族1
  case level2 = 2 // 贵族2
  case level3 = 3 // 贵族3
  case level4 = 4 // 贵族4
  case level5 = 5 // 贵族5
  case level6 = 6 // 贵族6
}

struct Permission: OptionSet, Codable, Equatable {
  var rawValue: UInt
  static let level1 = Permission(rawValue: 1<<0)
  static let level2 = Permission(rawValue: 1<<1)
  static let level4 = Permission(rawValue: 1<<2)
  static let level8 = Permission(rawValue: 1<<3)
}

struct NobleBaseInfoItem: Codable, Equatable {
  var desc           : String?         // 描述
  @ModelEnumWrapper
  var level: NobleLevelEnum?
  var permission: Permission?
  @LossyArray
  var datas: [ModelEnumWrapper<NobleLevelEnum>?]?
  
  enum CodingKeys: String, CodingKey {
    case desc
    case level
    case permission
    case datas
  }
}

extension UserDefaultsKey {
  static let buildinType = UserDefaultsKey(rawValue: "buildinType")
  static let derivedType = UserDefaultsKey(rawValue: "derivedType")
  static let nilableType = UserDefaultsKey(rawValue: "nilableType")
}
