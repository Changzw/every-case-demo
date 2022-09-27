//
//  RandomTestViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/7/30.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class RandomTestViewController: UIViewController {
  let a = A()
  let b = B()
  let c = C()
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(a)
    a.snp.makeConstraints{
      $0.width.height.equalTo(300)
      $0.center.equalToSuperview()
    }
    a.backgroundColor = .random
    a.addSubview(b)
    b.snp.makeConstraints{
      $0.top.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
    b.backgroundColor = .random
    a.addSubview(c)
    c.snp.makeConstraints{
      $0.right.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
    c.backgroundColor = .random
    view.addSubview(imageView)
    imageView.snp.makeConstraints{
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(300)
    }
    
DispatchQueue.global().async { [unowned self] in
  // Added autorelease pool
  for x in 1...12 {
    autoreleasepool {
      print("1---------")
      guard let url = Bundle.main.url(forResource: "\(x)", withExtension: "jpg"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
        return
      }
      
      DispatchQueue.main.async {
        print("2---------")
        self.imageView.image = image
      }
    }
  }
  print("3---------")
}
  
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
      print("begin------------")
      /*
       testdemo.RandomTestViewController -- #function
       testdemo.A -- #function (64.0, 313.0, 300.0, 300.0)
       testdemo.B -- #function (20.0, 20.0, 260.0, 260.0)
       begin------------
       testdemo.RandomTestViewController -- #function
       testdemo.A -- #function (64.0, 313.0, 300.0, 300.0)
       */
//      self.a.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      /*
       testdemo.RandomTestViewController -- #function
       testdemo.A -- #function (64.0, 313.0, 300.0, 300.0)
       testdemo.B -- #function (20.0, 20.0, 260.0, 260.0)
       begin------------
       testdemo.A -- #function (64.0, 313.0, 300.0, 300.0)
       testdemo.B -- #function (20.0, 20.0, 260.0, 260.0)
       testdemo.B -- #function (20.0, 20.0, 260.0, 260.0)
       */
      self.b.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print("\(Self.description()) -- #function")
  }
}

class A: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    print("\(Self.description()) -- #function \(frame)")
  }
}

class B: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    print("\(Self.description()) -- #function \(frame)")
  }
}

class C: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    print("\(Self.description()) -- #function \(frame)")
  }
}
