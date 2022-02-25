//
//  SpinView.swift
//  badamlive
//
//  Created by 常仲伟 on 2021/3/25.
//  Copyright © 2021 czw. All rights reserved.
//

import UIKit

struct SpiningParam {
  let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromBottom, .showHideTransitionViews]
  let spinDuration: TimeInterval = 1.0
}

final class SpinView: UIView {
  let primaryView: UIView
  let secondaryView: UIView
  
  var param = SpiningParam()
  
  override init(frame: CGRect) {
    primaryView = UIView()
    secondaryView = UIView()
    super.init(frame: frame)
    addSubview(primaryView)
    addSubview(secondaryView)
    secondaryView.isHidden = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    primaryView.frame = bounds
    secondaryView.frame = bounds
  }
  
  func flip() {
    UIView.transition(from: !primaryView.isHidden ? primaryView : secondaryView,
                      to: primaryView.isHidden ? primaryView : secondaryView,
                      duration: param.spinDuration,
                      options: param.transitionOptions) { (_) in
      
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    flip()
  }
}
