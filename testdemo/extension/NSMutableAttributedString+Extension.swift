//
//  NSMutableAttributedString+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/12/11.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
  
  func addLinkAttributed() {
    // We check URL and phone number
    let types: UInt64 = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
    do {
      let detector: NSDataDetector = try NSDataDetector(types: types)
      // Get NSTextCheckingResult array
      let matches: [NSTextCheckingResult] = detector.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: length))
      // Go through and check result
      for match in matches {
        if match.resultType == .link, let url = match.url {
          // Get URL
          addAttributes([NSAttributedString.Key.link : url,
                                       NSAttributedString.Key.foregroundColor : UIColor.blue,
                                       NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue ],
                                      range: match.range)
        } 
      }
    } catch {
      print(error)
    }
  }
}
