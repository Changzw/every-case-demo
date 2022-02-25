import UIKit
import SwiftUI

@_functionBuilder
struct Builder {
  static func buildBlock(_ partialResults: String...) -> String {
    partialResults.reduce("", +)
  }
}

@Builder
func abc() -> String {
  "Method: "
  "ABC"
}

struct Foo {
  @Builder
  var abc: String {
    "Getter: "
    "ABC"
  }
  
  @Builder
  subscript(_ anything: String) -> String {
    "sbscript: "
    "ABC"
  }
}

// test
func acceptBuilder(@Builder _ builder: () -> String) -> Void {
  print(builder())
}

func testBuilder() -> Void {
  print(abc())
  print(Foo().abc)
  print(Foo()["123"])
  acceptBuilder {
    "Closure Argument: "
    "ABC "
  }
}
testBuilder()

// --------
print("-------------")
@_functionBuilder
struct AttributedStringBuilder {
  // 基本方法
  static func buildBlock(_ parts: NSAttributedString...) -> NSAttributedString {
    let result = NSMutableAttributedString(string: "")
    parts.forEach(result.append)
    return result
  }
  
  // String 转成 NSAttributedString
  static func buildExpression(_ text: String) -> NSAttributedString {
    NSAttributedString(string: text)
  }
  
  // 转 UIImage
  static func buildExpression(_ image: UIImage) -> NSAttributedString {
    NSAttributedString(attachment: NSTextAttachment(image: image))
  }
  
  // 转自己，不是很清楚为什么一定要这个方法，感觉有上面几个就够了呀，但是实践上没有这个会报错
  static func buildExpression(_ attrString: NSAttributedString) -> NSAttributedString {
    attrString
  }
  
  // 支持 if 语句
  static func buildIf(_ attrString: NSAttributedString?) -> NSAttributedString {
    attrString ?? NSAttributedString()
  }
  
  // 支持 if/else 语句
  static func buildEither(first: NSAttributedString) -> NSAttributedString {
    first
  }
  static func buildEither(second: NSAttributedString) -> NSAttributedString {
    second
  }
}

extension NSAttributedString {
  // 帮助加 Attributes
  func withAttributes(_ attrs: [NSAttributedString.Key : Any]) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: self)
    result.addAttributes(attrs, range: NSRange(location: 0, length: self.length))
    return result
  }
  
  // 以 DSL 方式来初始化
  convenience init(@AttributedStringBuilder builder: () -> NSAttributedString) {
    self.init(attributedString: builder())
  }
}

struct AttributedStringRepresentable: UIViewRepresentable {
  
  let attrbutedString: NSAttributedString
  
  func makeUIView(context: Context) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.attributedText = attrbutedString
    return label
  }
  
  func updateUIView(_ uiView: UILabel, context: Context) { }
}

struct AttributedStringView: View {
  let optional = true
  
  var body: some View {
    AttributedStringRepresentable(attrbutedString: NSAttributedString{
      NSAttributedString {
        "Folder"
        UIImage(systemName: "folder")!
      }
      NSAttributedString { }
      "\n"
      NSAttributedString {
        "Document"
        UIImage(systemName: "doc")!
      }
      .withAttributes([
        .font : UIFont.systemFont(ofSize: 32),
        .foregroundColor : UIColor.red
      ])
      "\n"
      "Blue One".foregroundColor(.blue)
        .background(.gray)
        .underline(.cyan)
        .font(UIFont.systemFont(ofSize: 20))
      "\n"
      if optional {
        NSAttributedString {
          "Hello "
            .foregroundColor(.red)
            .font(UIFont.systemFont(ofSize: 10.0))
          "World"
            .foregroundColor(.green)
            .underline(.orange, style: .thick)
        }
        UIImage(systemName: "rays")!
      }
      "\n"
      if optional {
        "It's True".foregroundColor(.magenta)
          .font(UIFont.systemFont(ofSize: 28))
      } else {
        "It's False".foregroundColor(.purple)
      }
    })
  }
}
