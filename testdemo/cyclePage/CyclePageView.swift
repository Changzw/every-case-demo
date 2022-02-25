//
//  PageCollectionView.swift
//  testDemo
//
//  Created by czw on 10/18/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import NSObject_Rx

final class CyclePageLayout: UICollectionViewFlowLayout {
  override var flipsHorizontallyInOppositeLayoutDirection: Bool {
    return true
  }
}

protocol CyclePageItem { }
protocol CyclePageViewDelegate: class {
  func pageView(_ pageView: CyclePageView, didSelectItemAt index: Int)
  func pageView(_ pageView: CyclePageView, cellForItemAt index: Int) -> UICollectionViewCell
}

final class CyclePageView: UIView {
  private let cellClass: UICollectionViewCell.Type
  private let scrollDirection: UICollectionView.ScrollDirection
  weak var delegate: CyclePageViewDelegate?
  
  var items: [CyclePageItem] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  var selectedAt: ((Int)->())?
  var cellConfig: ((UICollectionViewCell, Int)->())?
  var pageTo: ((Int)->())?
  private var currnetIndex = 0
  private lazy var collectionView: UICollectionView = {
    let layout = CyclePageLayout()
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = self.scrollDirection
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.isPagingEnabled = true
    cv.scrollsToTop = false
    cv.showsHorizontalScrollIndicator = false
    cv.showsVerticalScrollIndicator = false
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()

//  let timer = Observable<Int>.timer(.seconds(1), period: .seconds(3), scheduler: MainScheduler())
//  init(cellClass: UICollectionViewCell.Type, scrollDirection: UICollectionView.ScrollDirection) {
//    self.cellClass = cellClass
//    self.scrollDirection = scrollDirection
//    super.init(frame: .zero)
//    addSubview(collectionView)
//    collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
//
//    timer
//      .subscribe(onNext: {[weak self] (v) in
//        guard let self = self else {return}
//        self.collectionView.scrollToItem(at: IndexPath(item: v, section: 0), at: .right, animated: true)
//      })
//      .disposed(by: rx.disposeBag)
//  }
  
  var cellType = UICollectionViewCell.self
  func register(_ cellClass: UICollectionViewCell.Type) {
    collectionView.register(cellClass, forCellWithReuseIdentifier: cellClass.description())
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension CyclePageView: UICollectionViewDelegate, UICollectionViewDataSource {
  private func index(for indexPath: IndexPath) -> Int {
    return indexPath.item % items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let idx = index(for: indexPath)
    if let select = selectedAt {
      select(idx)
    }else {
      delegate?.pageView(self, didSelectItemAt: idx)
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellClass.description(), for: indexPath)
    if let cellConfig = cellConfig {
      let idx = index(for: indexPath)
      cellConfig(cell, idx)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard items.count > 0 else { return }
    let idx = (indexPath.item + 1) % items.count
    if let page = pageTo {
      currnetIndex = idx
      page(idx)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 99999999
  }
}
