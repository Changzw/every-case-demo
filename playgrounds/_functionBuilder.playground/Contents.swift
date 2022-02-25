import UIKit
import SwiftUI

let stack = VStack {
  Text("Hello")
  Text("World")
  Button("I'm a button") {}
}
// Prints 'VStack<TupleView<(Text, Text, Button<Text>)>>'
print(type(of: stack))
print("===========================")


@resultBuilder struct TensorBuilder {
  static func buildBlock<T>(_ tensors: T...) -> [T] {
    tensors
  }
}

typealias Tensor = Array
extension Tensor {
  init(@TensorBuilder _ builder: () -> Self) {
    self = builder()
  }
}

let vector = Tensor {
  4;5;6
}

let matrix = Tensor {

  vector
  [1,2,3]
}

let tensor = Tensor {
  matrix
  Tensor {
    vector
    vector
  }
}

print(tensor)
print("===========================")

struct Setting {
  var name: String
  var value: Value
}

extension Setting {
  enum Value {
    case bool(Bool)
    case int(Int)
    case string(String)
    case group([Setting])
  }
}

let settings0 = [
  Setting(name: "Offline mode", value: .bool(false)),
  Setting(name: "Search page size", value: .int(25)),
  Setting(name: "Experimental", value: .group([
    Setting(name: "Default name", value: .string("Untitled")),
    Setting(name: "Fluid animations", value: .bool(true))
  ]))
]

@resultBuilder
struct SettingsBuilder {
  static func buildBlock(_ settings: Setting...) -> [Setting] {
    settings
  }
}

func makeSettings(@SettingsBuilder _ content: () -> [Setting]) -> [Setting] {
  content()
}

let settings1 = makeSettings {
  Setting(name: "Offline mode", value: .bool(false))
  Setting(name: "Search page size", value: .int(25))

  Setting(name: "Experimental", value: .group([
    Setting(name: "Default name", value: .string("Untitled")),
    Setting(name: "Fluid animations", value: .bool(true))
  ]))
}

print(settings1)


struct SettingsGroup {
  var name: String
  var settings: [Setting]
  
  init(name: String, @SettingsBuilder builder: () -> [Setting]) {
    self.name = name
    self.settings = builder()
  }
}

SettingsGroup(name: "Experimental") {
  Setting(name: "Default name", value: .string("Untitled"))
  Setting(name: "Fluid animations", value: .bool(true))
}

protocol SettingsConvertible {
  func asSettings() -> [Setting]
}

extension Setting: SettingsConvertible {
  func asSettings() -> [Setting] { [self] }
}

extension SettingsGroup: SettingsConvertible {
  func asSettings() -> [Setting] {
    [Setting(name: name, value: .group(settings))]
  }
}

extension SettingsBuilder {
  static func buildBlock(_ values: SettingsConvertible...) -> [Setting] {
    values.flatMap { $0.asSettings() }
  }
}

let settings2 = makeSettings {
  Setting(name: "Offline mode", value: .bool(false))
  Setting(name: "Search page size", value: .int(25))
  
  SettingsGroup(name: "Experimental") {
    Setting(name: "Default name", value: .string("Untitled"))
    Setting(name: "Fluid animations", value: .bool(true))
  }
}

extension Array: SettingsConvertible where Element == Setting {
  func asSettings() -> [Setting] { self }
}

extension SettingsBuilder {
  static func buildIf(_ value: SettingsConvertible?) -> SettingsConvertible {
    value ?? []
  }
  static func buildEither(first: SettingsConvertible) -> SettingsConvertible {
    first
  }
  
  static func buildEither(second: SettingsConvertible) -> SettingsConvertible {
    second
  }
}

let settings3 = makeSettings {
  Setting(name: "Offline mode", value: .bool(false))
  Setting(name: "Search page size", value: .int(25))
  
  // Compiler error: Closure containing control flow statement
  // cannot be used with function builder 'SettingsBuilder'.
  if true {
    SettingsGroup(name: "Experimental") {
      Setting(name: "Default name", value: .string("Untitled"))
      Setting(name: "Fluid animations", value: .bool(true))
    }
  }
}
