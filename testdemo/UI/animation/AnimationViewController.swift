//
//  AnimationViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/2/1.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
  
  let v = UIView()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    v.backgroundColor = .red
    v.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.addSubview(v)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let anim = CAKeyframeAnimation(keyPath: "position")
    let o = v.center
    let f0 = o
    let f1 = CGPoint(x: o.x, y: o.y+100)
    let f2 = CGPoint(x: o.x, y: o.y+100)
    let f3 = CGPoint(x: o.x, y: o.y+1000)

    anim.values = [f0, f1, f2, f3].map{ NSValue.init(cgPoint: $0) }
    anim.keyTimes = [0, 0.01, 0.99, 1]
    anim.isRemovedOnCompletion = true
    anim.duration = 5

    v.layer.add(anim, forKey: nil)
//    let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
//    wobble.duration = 0.25
//    wobble.repeatCount = 4
//    wobble.values = [0.0, -.pi/4.0, 0.0, .pi/4.0, 0.0]
//    wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
//    v.layer.add(wobble, forKey: nil)
  }
}
