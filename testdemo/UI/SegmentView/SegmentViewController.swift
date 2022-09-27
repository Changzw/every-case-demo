//
//  SegmentViewController.swift
//  testdemo
//
//  Created by Fri on 2022/9/27.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

private final class ItemView: UIControl {
  let label = UILabel().then {
    $0.textColor = .white
    $0.textAlignment = .center
  }
  private let bag = DisposeBag()
  var click: ((ItemView)->())?
  init(title: String) {
    super.init(frame: .zero)
    addSubview(label)
    label.snp.makeConstraints{
      $0.centerY.leading.trailing.equalToSuperview()//.inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    label.text = title//"\(Int64.random(in: 100...10000000000000))"
    label.backgroundColor = .random
    rx.controlEvent(.touchUpInside)
      .bind{[unowned self] in
        self.click?(self)
      }
      .disposed(by: bag)
    
//    snp.makeConstraints{
//      $0.width.equalTo(52).priority(.low)
//    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private final class SegmentView: UIView {
  let scrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .random
  }
  let selectedBackgroundView = UIView().then{
    $0.backgroundColor = .cyan
  }
  
  lazy var stackView = HStack{
//    Array<ItemView>()
    ["AAAAAAAAAAA",
     "52",
     "BBBBBBBBBBB",
     "KFC",
     "MEMC",
     "火车头",
     "兴隆湖",
     "沙特阿拉伯",
     "石油",]
      .map(ItemView.init(title:))
      .map{ item -> ItemView in
        item.click = {[weak self] in
          self?.select(item: $0)
        }
        return item
      }
  }.spacing(22)
  
  var selectedIndex: Int = 0 {
    didSet {
      
    }
  }
  
  var items: [UIView] {
    stackView.arrangedSubviews
  }
  
  var selectedItem: ItemView? = nil {
    didSet {
      
    }
  }
  
  init(selectedIndex: Int) {
    self.selectedIndex = selectedIndex
    super.init(frame: .zero)
    addSubview(scrollView)
    scrollView.addSubview(selectedBackgroundView)
    scrollView.addSubview(stackView)
    scrollView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    stackView.snp.makeConstraints{
      $0.edges.equalToSuperview()
      $0.height.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func select(item: ItemView) {
    var frame = item.frame
    selectedItem?.snp.remakeConstraints{
      $0.width.equalTo(52).priority(.low)
    }
    if frame.width <= 52 {
      item.snp.remakeConstraints{
        $0.width.equalTo(52).priority(.required)
      }
      frame.size.width = 52
    }
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      self.selectedBackgroundView.frame = frame.inset(by: UIEdgeInsets(top: -10, left: -8, bottom: -4, right: -8))
      self.layoutIfNeeded()
    }
    selectedItem = item
  }
  
  func focusing(offset: Int) {
    
  }
}

class SegmentViewController: UIViewController {

  private let seg = SegmentView(selectedIndex: 0)
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(seg)
    seg.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.height.equalTo(44)
    }
  }
  
}
