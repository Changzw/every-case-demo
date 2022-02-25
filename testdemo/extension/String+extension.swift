//
//  String+extension.swift
//  badamlive
//
//  Created by 常仲伟 on 2020/9/25.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

//正则整理 https://blog.csdn.net/h643342713/article/details/54292935
extension String {
  func isChinese() -> Bool {
    guard let regularExp = try? NSRegularExpression(pattern: "^[\u{4e00}-\u{9fa5}]", options:NSRegularExpression.Options.caseInsensitive) else { return false }
    return regularExp.numberOfMatches(
      in: self,
      options: NSRegularExpression.MatchingOptions.reportProgress,
      range: NSRange(location: 0, length: count)) > 0
  }
  
  func isEnglish() -> Bool {
    let regex = "[a-zA-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: self)
    return inputString
  }

  func inputChineseOrLettersAndNumbersNum() -> Bool {
    let regex = "[\u{4e00}-\u{9fa5}]+[A-Za-z0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: self)
    return inputString
  }
  
  func isNumber() -> Bool {
    guard count > 0 else { return false }
    let numString = "[0-9]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
    let number = predicate.evaluate(with: self)
    return number
  }
  
  func containUyghur() -> Bool {
    // Uyghur:   U+0600 - U+06FF, http://www.blogjava.net/baicker/archive/2007/11/16/160932.html
    for c in self {
      if ("\u{0600}" <= c && c <= "\u{06FF}") {
        return true
      }
    }
    return false
  }
  
  func printJson() {
    guard let data = self.data(using: .utf8),
          let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
          let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
          let prettyString = String(data: prettyData, encoding: .utf8)
    else {
      print("打印 Json 错误： \(self)")
      return
    }
    print(prettyString)
  }
  
  func string(from originDateFormat: String, to newDateFormat: String) -> Self? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = originDateFormat
    if let date = dateFormatter.date(from: self) {
      dateFormatter.dateFormat = newDateFormat
      return dateFormatter.string(from: date)
    } else {
      return nil
    }
  }
  
  func date(from dateFormat: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.date(from: self)
  }
  
}

//MARK: - md5
extension String {
  func md5() -> String {
    let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
    var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    CC_MD5_Init(context)
    CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
    CC_MD5_Final(&digest, context)
    context.deallocate()
    var hexString = ""
    for byte in digest {
      hexString += String(format:"%02x", byte)
    }
    
    return hexString
  }
}

//MARK: - RTL
extension String {
  var ltr: String {
    "\u{200E}" + self
  }
  
  var rtl: String {
    "\u{200F}" + self
  }
}

//MARK: - Number Changing
extension String {
  var int: Int? {
    Int(self)
  }
  
  var float: Float {
    (self as NSString).floatValue as Float
  }
  
  var double: Double {
    (self as NSString).doubleValue as Double
  }
}

//MARK: - json
extension String {
  func toObject<T: Codable>(_ type: T.Type) -> T? {
    guard let data = data(using: .utf8),
          let obj = try? JSONDecoder().decode(type, from: data) else { return nil }
    return obj
  }
}
