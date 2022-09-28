//
//  AutoLayoutSegmentView.swift
//  testdemo
//
//  Created by Fri on 2022/9/28.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class SegmentTabItemView: UIControl {
  private let fakelabel = UILabel().then {
    $0.isHidden = true
  }
  private let label = UILabel().then {
    $0.textColor = .white
    $0.textAlignment = .center
  }
  private let bag = DisposeBag()
  var click: ((SegmentTabItemView)->())?
  private(set) var titleLenght: CGFloat = 0
  
  init(title: String) {
    super.init(frame: .zero)
    addSubview(fakelabel)
    addSubview(label)
    fakelabel.snp.makeConstraints{
      $0.centerY.leading.trailing.equalToSuperview()
    }
    label.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
    fakelabel.text = title
    label.text = title
    fakelabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    rx.controlEvent(.touchUpInside)
      .bind{[unowned self] in
        self.click?(self)
      }
      .disposed(by: bag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard titleLenght == 0 else { return }
    titleLenght = label.bounds.width
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class AutoLayoutSegmentView: UIView {
  let scrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .random
  }
  let selectedBackgroundView = UIView().then{
    $0.backgroundColor = .cyan
  }
  
  lazy var items = ["AAAAAAAAAAA",
               "52",
               "BBBBBBBBBBB",
               "KFC",
               "MEMC",
               "火车头",
               "兴隆湖",
               "沙特阿拉伯",
               "石油",]
                .map(SegmentTabItemView.init(title:))
                .map{ item -> SegmentTabItemView in
                  item.click = {[weak self] in
                    self?.click(item: $0)
                  }
                  return item
                }
  
  lazy var stackView = HStack{
    items
  }.spacing(22)
  
  var selectedIndex: Int = 0 {
    didSet {
      select(index: selectedIndex)
    }
  }
  
  var didSelectedIndex: ((Int) -> ())?
  private(set) var selectedItem: SegmentTabItemView!
  init(selectedIndex: Int) {
    self.selectedIndex = selectedIndex
    super.init(frame: .zero)
    selectedItem = items[selectedIndex]
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
    
    select(index: selectedIndex)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func move(index: Int, percent: CGFloat) {
    guard let selItem = selectedItem else { return }
    let destIndex = index + (percent>0 ? 1 : -1)
    guard destIndex >= 0 && destIndex < items.count else {
      return
    }
    
    let destItem = items[destIndex]
    let distance = abs(selItem.frame.midX - destItem.frame.midX)
    let offset = distance * percent
    selectedBackgroundView.snp.updateConstraints{
      $0.centerX.equalTo(selItem).offset(offset)
    }
  }
  
  private func click(item: SegmentTabItemView) {
    guard let idx = items.firstIndex(of: item) else { return }
    select(index: idx)
    didSelectedIndex?(idx)
  }
  
  private func select(index: Int) {
    let item = items[index]
    var frame = item.frame
    if frame == .zero {// for init frame is zero
      frame.size = item.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    selectedItem.snp.remakeConstraints{
      $0.width.equalTo(52).priority(.low)
    }
    if frame.width <= 52 {
      item.snp.remakeConstraints{
        $0.width.equalTo(52).priority(.required)
      }
    }
    selectedBackgroundView.snp.remakeConstraints{
      $0.height.equalTo(item).offset(14)
      $0.width.equalTo(item).offset(16)
      $0.centerX.equalTo(item).offset(0)
    }
    
    UIView.animate(withDuration: 0.3, animations: {
      self.layoutIfNeeded()
    }) { res in
      guard res else {return}
      self.centering(item: item)
    }
    selectedItem = item
  }
  
  private func centering(item: SegmentTabItemView) {
    let deltaX = bounds.midX - (item.frame.midX - scrollView.contentOffset.x)
    var offsetX = scrollView.contentOffset.x - deltaX
    let maxOffsetX = scrollView.contentSize.width - bounds.width

    if offsetX < 0 {
      offsetX = 0
    }else if offsetX > maxOffsetX {
      offsetX = maxOffsetX
    }
    scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
  }
}
