//
//  UILabel+Extension.swift
//  badamlive
//
//  Created by 刘俊华 on 2020/12/9.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func textWidth() -> CGFloat {
    guard let text = self.text else { return  0 }
    let frame = (text as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)),
                                                options: [NSStringDrawingOptions.usesLineFragmentOrigin],
                                                attributes: [NSAttributedString.Key.font: font!],
                                                context: nil)
    return frame.size.width
  }
}
