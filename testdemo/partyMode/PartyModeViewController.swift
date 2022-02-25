//
//  PartyModeViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/8/9.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class PartyModeViewController: UIViewController {
  
  let playerView = UIView()
  lazy var seatView = UIStackView(arrangedSubviews: (0..<6).map {_ in
    let v = UIView()
    v.backgroundColor = .random
    return v
  })
  
  let carrouselView = CarrouselView(frame: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .random
    playerView.backgroundColor = .random
    
    let containerView = UIStackView(arrangedSubviews: [
      seatView,
      playerView
    ])
    view.addSubview(containerView)
    containerView.snp.makeConstraints{
      $0.right.left.equalToSuperview()
      $0.top.equalToSuperview().offset(150)
      $0.bottom.equalToSuperview().offset(-50)
    }

    playerView.addSubview(carrouselView)
    carrouselView.snp.makeConstraints{
      $0.top.left.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(13)
    }
    carrouselView.backgroundColor = .random
    seatView.axis = .vertical
    seatView.distribution = .fillEqually
    seatView.snp.makeConstraints{
      $0.width.equalTo(playerView.snp.height).dividedBy(6)
    }
    seatView.isHidden.toggle()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    carrouselView.start()
  }
}
