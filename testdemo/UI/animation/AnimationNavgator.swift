//
//  AnimationNavgator.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/6.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit

enum AnimationChapter: CaseIterable, ViewControllerMaker, Navigation {
  case animation

  var viewController: UIViewController {
    switch self {
    case .animation:  return AnimationViewController()
    }
  }
  
}
