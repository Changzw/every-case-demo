//
//  Date+Extension.swift
//  badamlive
//
//  Created by Daniels on 2020/10/17.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

extension Date {
  func string(form dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: self)
  }
  
  func isToday() -> Bool {
    Calendar.current.isDateInToday(self)
  }
}
