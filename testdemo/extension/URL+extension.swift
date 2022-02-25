//
//  UIImage+extension.swift
//  badamlive
//
//  Created by czw on 9/17/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

extension URL {
  static func gif(name: String) -> URL? {
    Bundle.main.url(forResource: name, withExtension: "gif")
  }
  
  static func queryAllow(_ string: String?) -> URL? {
    guard let str = string?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: str) else { return nil }
    return url
  }
  
  mutating func appendQueryItem(name: String, value: String?) {
    guard var urlComponents = URLComponents(string: absoluteString) else { return }
    var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
    let queryItem = URLQueryItem(name: name, value: value)
    queryItems.append(queryItem)
    urlComponents.queryItems = queryItems
    self = urlComponents.url!
  }
}
