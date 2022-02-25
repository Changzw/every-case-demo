//
//  PresentFromViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/3/12.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class PresentFromViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    let iv = UIImageView(image: UIImage(named: "00000"))
    view.addSubview(iv)
    iv.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    present(CustomPresentationViewController(), animated: true, completion: nil)
  }
  
  
}
