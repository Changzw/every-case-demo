//
//  CustomPresentationViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/3/9.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class PointTestView: UIView {
  class InnerView: UIView {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      print(000000)
    }
  }
  var v = InnerView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(v)
    v.backgroundColor = .red
    v.snp.makeConstraints{
      $0.top.bottom.centerX.equalToSuperview()
      $0.width.equalTo(50)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return v.frame.contains(point)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("11111111")
  }
}

class CustomPresentationViewController: UIViewController {
  let contentView = UIView()
  var contentOriginPoint = CGPoint.zero
  
  var p1 = PointTestView()
  var p2 = PointTestView()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
//    view.addSubview(contentView)
//    contentView.snp.makeConstraints{
//      $0.width.equalTo(300)
//      $0.edges.equalToSuperview().priority(UILayoutPriority.fittingSizeLevel)
//    }
    
    let l = UILabel()
    l.text = "adfljkadfja;sldfjaadsjf;aljdkf;adsfjas;dlgjkasd;"
    l.numberOfLines = 0
    contentView.backgroundColor = .white
    contentView.addSubview(l)
    l.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    view.addSubview(p1)
    view.addSubview(p2)
    
    p1.backgroundColor = .purple
    p1.snp.makeConstraints{
      $0.centerY.left.right.equalToSuperview()
      $0.height.equalTo(50)
    }
    p2.backgroundColor = .purple
    p2.snp.makeConstraints{
      $0.left.right.equalToSuperview()
      $0.height.equalTo(50)
      $0.top.equalTo(p1.snp.bottom).offset(40)
    }
  }
  
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//    var frame = view.frame
//    let contentSize = contentView.bounds.size
//    if frame.size != contentSize {
//      frame.size = contentSize
//      frame.origin = contentOriginPoint
//      view.frame = frame
//    }else {
//      contentOriginPoint = frame.origin
//    }
//  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print(222222)
  }
}
