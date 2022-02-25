//
//  MatrixViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/5/11.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

fileprivate class ContentView: UIView {
  let label = UILabel()
  let image = UIImageView(image: UIImage(named: "gender_female"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    label.numberOfLines = 0
    let stackView = UIStackView(arrangedSubviews: [label, image])
    stackView.spacing = 10
    stackView.alignment = .center
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    image.setContentHuggingPriority(.required, for: .horizontal)
    addSubview(stackView)
    stackView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    label.snp.makeConstraints{
      $0.width.greaterThanOrEqualTo(50)
    }

//    addSubview(label)
//    addSubview(image)
//    label.snp.makeConstraints{
//      $0.left.top.bottom.equalToSuperview()
//      $0.width.lessThanOrEqualTo(50)
//    }
//    image.snp.makeConstraints{
//      $0.top.bottom.right.equalToSuperview()
//      $0.left.equalTo(label.snp.right).offset(10)
//    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    isHidden = true
  }
}

class MatrixViewController: UIViewController {
  
  private lazy var row0: UIStackView = {
    let s = UIStackView()
    s.spacing = 10
    s.axis = .horizontal
    s.alignment = .top
    return s
  }()
  private lazy var row1: UIStackView = {
    let s = UIStackView()
    s.spacing = 10
    s.axis = .horizontal
    s.alignment = .top
    return s
  }()
  private lazy var row2: UIStackView = {
    let s = UIStackView()
    s.spacing = 10
    s.axis = .horizontal
    s.alignment = .top
    return s
  }()
  private lazy var stackView: UIStackView = {
    let s = UIStackView()
    s.spacing = 10
    s.axis = .vertical
    s.alignment = .leading
    return s
  }()

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    row0.isHidden = row0.arrangedSubviews.count == 0
    row1.isHidden = row1.arrangedSubviews.count == 0
    row2.isHidden = row2.arrangedSubviews.count == 0
  }
  
  private var v: ContentView!
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints{
      $0.left.equalToSuperview()
      $0.right.lessThanOrEqualToSuperview()
      $0.top.equalToSuperview().offset(100)
    }
    stackView.layer.borderWidth = 2
    stackView.layer.borderColor = UIColor.black.cgColor
    var lastLabel: UILabel!
    for i in 0..<3 {
      let a = ContentView()
      a.label.text = "text:" + "\(i)"
      row0.addArrangedSubview(a)
      lastLabel = a.label
    }
    lastLabel.text = "asdflkjadf;lakjsdf;alksjg;alskjdga;lsdkfja;sldfjka;sdlkfja;sdljgkfa;sljgk"
    for i in 0..<3 {
      let a = ContentView()
      a.label.text = "text:" + "\(i)"
      row1.addArrangedSubview(a)
    }
    for i in 0..<3 {
      let a = ContentView()
      a.label.text = "text:" + "\(i)"
      row2.addArrangedSubview(a)
      v = a
      lastLabel = a.label
    }
    lastLabel.text = "asdflkjadf;lakjsdf;alksjg;alskjdga;lsdkfja;sldfjka;sdlkfja;sdljgkfa;sljgk"
    stackView.addArrangedSubview(row0)
    stackView.addArrangedSubview(row1)
    stackView.addArrangedSubview(row2)
  }
  
  func updateData() {
    stackView.arrangedSubviews.compactMap{
      $0 as? UIStackView
    }
    .map{ v -> [UIView] in
      v.isHidden = false
      return v.arrangedSubviews
    }
    .flatMap{ $0 }
    .forEach{
      $0.isHidden = false
    }
  }
  
  static var vvv = false
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !Self.vvv {
      v.snp.remakeConstraints{
        $0.height.equalTo(100)
      }
    }else {
      v.snp.remakeConstraints{
        $0.height.equalTo(500)
      }

    }
//    guard let t = touches.first else { return }
//    let pt = t.location(in: view)
//    guard !stackView.frame.contains(pt) else { return }
//    updateData()
  }
}
