//
//  DeepLink.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import UIKit

struct DeepLinkContext {
  var webParams: [String: Any]?
  var url: String?
  let fromViewController: UIViewController
}

protocol DeepLinkHandler {
  func handle(context: DeepLinkContext)
  func canHandle(context: URLComponents) -> Bool
}
