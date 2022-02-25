//
//  XibDemoViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/20.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit

class XibDemoViewController: UIViewController {
  
  @IBOutlet var shadowView: CornerShadowView!

  override func viewDidLoad() {
    super.viewDidLoad()
    shadowView.topLeft = true
    shadowView.topRight = true
    shadowView.shadowRadius = 20
    shadowView.shadowColor = .green
    shadowView.shadowOffset = CGSize(width: 30, height: 30)
    
    let progressView0 = Bundle.loadView(withType: ProgressBarView.self)
    view.addSubview(progressView0)
    progressView0.snp.makeConstraints { (m) in
      m.top.equalTo(shadowView.snp.bottom).offset(10)
      m.left.right.equalToSuperview()
      m.height.equalTo(10)
    }
    let progressView1 = ProgressBarView.loadFromNib()
    view.addSubview(progressView1)
    progressView1.snp.makeConstraints { (m) in
      m.top.equalTo(progressView0.snp.bottom).offset(10)
      m.left.right.equalToSuperview()
      m.height.equalTo(10)
    }

  }
}
