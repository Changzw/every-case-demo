//
//  RandomTestViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/7/30.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class RandomTestViewController: UIViewController {
  
  let imageView = UIImageView(image: UIImage(named: "pk_result_winner_big"))
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .random
    
    let vc = UIViewController()
    let nav = UINavigationController(rootViewController: vc)
    nav.setNavigationBarHidden(true, animated: false)
    vc.view.backgroundColor = .random
    addChild(nav)
    view.addSubview(nav.view)
    nav.view.snp.makeConstraints{
      $0.top.equalTo(view.snp.centerY)
      $0.left.right.bottom.equalToSuperview()
    }
    
    vc.view.addSubview(imageView)
    imageView.snp.makeConstraints{
      $0.centerY.equalTo(vc.view.snp.top)
      $0.centerX.equalToSuperview()
    }
    vc.view.clipsToBounds = false 
    nav.view.clipsToBounds = false
  }
  
  func createShadowLayer() -> CALayer {
    let shadowLayer = CALayer()
    shadowLayer.shadowColor = UIColor.red.cgColor
    shadowLayer.shadowOffset = CGSize.zero
    shadowLayer.shadowRadius = 5.0
    shadowLayer.shadowOpacity = 0.8
    shadowLayer.backgroundColor = UIColor.clear.cgColor
    return shadowLayer
  }

}
