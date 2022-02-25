//
//  SimpleAnimatorViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/5/17.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

fileprivate struct Path {
  let start: CGPoint
  let end: CGPoint
  let routeNo: Int
  let duration: Double
}

class SimpleAnimatorViewController: UIViewController {
  
  let enviromentView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(enviromentView)
    enviromentView.snp.makeConstraints{
      $0.center.equalToSuperview()
      $0.width.height.equalTo(300)
    }
    
    
  }
  
  
}
