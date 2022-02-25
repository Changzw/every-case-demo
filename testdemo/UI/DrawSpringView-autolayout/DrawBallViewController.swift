//
//  DrawBallViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import SnapKit

class DrawBallViewController: UIViewController {
  enum Position: Int {
    case left, mid, right
  }
  
  let label = UILabel()
  
  let iconView = UIView()
  let containerView = UIView()
  var animator: UIViewPropertyAnimator?
  var leftToSuperLeftConstraint: Constraint?
  var leftToIconLeftConstraint: Constraint?
  var leftToIconRightConstraint: Constraint?
  var rightToSuperRightConstraint: Constraint?
  var rightToIconRightConstraint: Constraint?
  var rightToIconLeftConstraint: Constraint?
  
  var labelPosition = Position.right
  
  override func viewDidLoad() {
    super.viewDidLoad()
    iconView.layer.cornerRadius = 30
    label.text = "asdfjl;sdfjl;aksdfja;sdfjl;aksdfja;aksdfja;lds"
    label.numberOfLines = 2
    
    view.backgroundColor = .white
    iconView.backgroundColor = .random
    containerView.backgroundColor = .lightGray
    
    view.addSubview(containerView)
    containerView.addSubview(label)
    containerView.addSubview(iconView)
    
    containerView.snp.makeConstraints{
      $0.width.equalTo(300)
      $0.height.equalTo(60)
      $0.center.equalToSuperview()
    }
    iconView.snp.makeConstraints{
      $0.width.height.equalTo(60)
      $0.center.equalToSuperview()
    }
    
    label.snp.makeConstraints{
      $0.top.bottom.equalToSuperview()
      leftToSuperLeftConstraint = $0.left.equalToSuperview().constraint
      leftToIconLeftConstraint = $0.left.equalTo(iconView).constraint
      leftToIconRightConstraint = $0.left.equalTo(iconView.snp.right).constraint
      rightToSuperRightConstraint = $0.right.equalToSuperview().constraint
      rightToIconRightConstraint = $0.right.equalTo(iconView).constraint
      rightToIconLeftConstraint = $0.right.equalTo(iconView.snp.left).constraint
    }
  }
  
  var positionCount: Int = 0
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    labelPosition = Position(rawValue: positionCount % 3)!
    positionCount+=1
    leftToSuperLeftConstraint?.deactivate()
    leftToIconLeftConstraint?.deactivate()
    leftToIconRightConstraint?.deactivate()
    rightToSuperRightConstraint?.deactivate()
    rightToIconRightConstraint?.deactivate()
    rightToIconLeftConstraint?.deactivate()
    
    label.isHidden = false
    switch labelPosition {
    case .left:
      leftToSuperLeftConstraint?.activate()
      rightToIconLeftConstraint?.activate()
    case .right:
      leftToIconRightConstraint?.activate()
      rightToSuperRightConstraint?.activate()
    case .mid:
      leftToIconLeftConstraint?.activate()
      rightToIconRightConstraint?.activate()
      label.isHidden = true
    }

    let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: UISpringTimingParameters())
    animator.addAnimations {
      self.view.layoutIfNeeded()
    }
    animator.startAnimation()
    self.animator = animator
  }
}
