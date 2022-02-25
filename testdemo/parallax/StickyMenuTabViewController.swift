//
//  StickyMenuTabViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/4/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import PagingKit
import SnapKit
import RxGesture
import NSObject_Rx

final class StickyMenuTabViewController: UIViewController {
  let headerView = UIView()
  let headerTitles = ["平台送礼榜", "平台收礼榜"]
  var viewControllerCache = [String: UIViewController]()
  
  private var headerTopConstraint: Constraint?
  
  private lazy var menuViewController: PagingMenuViewController = {
    let m = PagingMenuViewController()
    m.dataSource = self
    m.delegate = self
    m.view.backgroundColor = .white
    m.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: TitleLabelMenuViewCell.description())
    return m
  }()
  
  private lazy var contentViewController: PagingContentViewController = {
    let c = PagingContentViewController()
    c.view.backgroundColor = .white
    c.dataSource = self
    c.delegate = self
    c.scrollView.bounces = false
    return c
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
   
  private var dragPreviousY: CGFloat = 0
  private var dragDirection: StickyMenuItemDragDirection = .up

  private func setupBinding() {
    menuViewController.reloadData()
    contentViewController.reloadData()
    headerView.rx.panGesture()
      .subscribe(onNext: {[unowned self]  in
        var dragYDiff : CGFloat
        switch $0.state {
          case .began:
            dragPreviousY = $0.location(in: self.view).y
          case .changed:
            let dragCurrentY = $0.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .down : .up
            itemViewDidScroll(withDistance: dragYDiff)
          case .ended:
            itemViewScrollEnded(withScrollDirection: dragDirection)
          default: return
        }
      })
      .disposed(by: rx.disposeBag)
  }
  
  func setupUI() {
    view.backgroundColor = .white
    headerView.backgroundColor = .red
    
    view.addSubview(headerView)
    headerView.snp.makeConstraints{
      $0.left.right.equalToSuperview()
      headerTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).constraint
      $0.height.equalTo(100)
    }
    
    menuViewController.willMove(toParent: self)
    addChild(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParent: self)
    
    menuViewController.view.snp.makeConstraints { (mk) in
      mk.left.right.equalToSuperview()
      mk.top.equalTo(headerView.snp.bottom)
      mk.height.equalTo(44)
    }
    
    contentViewController.willMove(toParent: self)
    addChild(contentViewController)
    view.addSubview(contentViewController.view)
    contentViewController.didMove(toParent: self)
    contentViewController.view.snp.makeConstraints { (mk) in
      mk.left.right.equalToSuperview()
      mk.top.equalTo(menuViewController.view.snp.bottom)
      mk.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  func scrollToInitialView() {
    guard let top = headerTopConstraint?.layoutConstraints.first?.constant else {return}
    headerTopConstraint?.layoutConstraints.first?.constant = headerTopRange.upperBound
    let distant = headerTopRange.upperBound - top
    
    var time = distant / 500
    if time < 0.1 {
      time = 0.1
    }
    UIView.animate(withDuration: TimeInterval(time), animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  func scrollToFinalView() {
    guard let top = headerTopConstraint?.layoutConstraints.first?.constant else {return}
    headerTopConstraint?.layoutConstraints.first?.constant = headerTopRange.lowerBound
    let distant = top - headerTopRange.lowerBound
    var time = distant / 300
    if time < 0.2 {
      time = 0.2
    }
    UIView.animate(withDuration: TimeInterval(time), animations: {
      self.view.layoutIfNeeded()
    })
  }
}

extension StickyMenuTabViewController: StickyMenuItemViewControllerDelegate {
  var currentHeaderTop: CGFloat {
    headerTopConstraint?.layoutConstraints.first?.constant ?? 100
  }
  
  var headerTopRange: Range<CGFloat> {
    CGFloat(-100)..<CGFloat(0)
  }

  func itemViewDidScroll(withDistance scrollDistance: CGFloat) {
    guard var constant = headerTopConstraint?.layoutConstraints.first?.constant else {return}
    constant -= scrollDistance
    if constant < headerTopRange.lowerBound {
      constant = headerTopRange.lowerBound
    }
    if constant > headerTopRange.upperBound {
      constant = headerTopRange.upperBound
    }
    headerTopConstraint?.layoutConstraints.first?.constant = constant
  }
  
  func itemViewScrollEnded(withScrollDirection direction: StickyMenuItemDragDirection) {
    switch direction {
      case .down: scrollToInitialView()
      case .up:   scrollToFinalView()
    }
  }
}

extension StickyMenuTabViewController: PagingMenuViewControllerDataSource {
  func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
    let cell = viewController.dequeueReusableCell(withReuseIdentifier: TitleLabelMenuViewCell.description(), for: index)  as! TitleLabelMenuViewCell
    cell.titleLabel.text = headerTitles[index]
    cell.focusColor = .red
    cell.normalColor = UIColor.red.withAlphaComponent(0.5)
    return cell
  }
  
  func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
    viewController.view.bounds.width / CGFloat(headerTitles.count)
  }
  
  func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
    headerTitles.count
  }
}

extension StickyMenuTabViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    headerTitles.count
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    if let vc = viewControllerCache[headerTitles[index]] {
      return vc
    }else {
      let vc = StickyMenuItemViewController()//index == 0 ?  : SecondMenuContainerViewController()
      vc.delegate = self
      viewControllerCache[headerTitles[index]] = vc
      return vc
    }
  }
}

extension StickyMenuTabViewController: PagingMenuViewControllerDelegate {
  func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
    contentViewController.scroll(to: page, animated: true)
  }
}

extension StickyMenuTabViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
    menuViewController.scroll(index: index, percent: percent, animated: false)
  }
}
