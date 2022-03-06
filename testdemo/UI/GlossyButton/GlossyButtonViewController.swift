//
//  GlossyButtonViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import RxSwift

class GlossyButtonViewController: UIViewController {
  
  let button = CoolButton(type: .custom)
  let labelHue = UILabel().then {
    $0.text = "Hue"
  }
  let labelSat = UILabel().then {
    $0.text = "Sat"
  }
  let labelBri = UILabel().then {
    $0.text = "Bri"
  }
  let sliderHue = UISlider()
  let sliderSat = UISlider()
  let sliderBri = UISlider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(button)
    button.snp.makeConstraints{
      $0.width.equalTo(200)
      $0.height.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    
    let content = VStack {
      labelHue
      sliderHue
      labelSat
      sliderSat
      labelBri
      sliderBri
    }
    .spacing(40)
    .alignment(.fill)
    .insetAll(20)
    
    view.addSubview(content)
    content.snp.makeConstraints{
      $0.top.equalTo(button.snp.bottom).offset(20)
      $0.left.right.equalToSuperview()
    }
    
    sliderHue.rx.value
      .bind{ [unowned self] in
        self.button.hue = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
    sliderSat.rx.value
      .bind{ [unowned self] in
        self.button.saturation = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
    sliderBri.rx.value
      .bind{ [unowned self] in
        self.button.brightness = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
  }
}
