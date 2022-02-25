//
//  TFristViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class TFristViewController: UIViewController {
  private let customTransitionDelegate = Custom1TransitioningDelegate()
  init() {
    super.init(nibName: nil, bundle: nil)
    //    modalTransitionStyle = .flipHorizontal
    transitioningDelegate = customTransitionDelegate
    modalPresentationStyle = .custom
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .random
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    dismiss(animated: true, completion: nil)
  }
}

