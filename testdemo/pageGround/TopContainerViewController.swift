//
//  TopContainerViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/7.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import PagingKit

class TopContainerViewController: UIViewController {
  let headerTitles = ["平台送礼榜", "平台收礼榜"]
  var viewControllerCache = [String: UIViewController]()
  
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
  
  let closeButton = UIButton(type: .custom)
  
  @objc func close() {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    closeButton.setImage(UIImage(named: "live_room_hose_close_other"), for: .normal)
    closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

    view.backgroundColor = .white
    menuViewController.willMove(toParent: self)
    addChild(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParent: self)
    
    menuViewController.view.snp.makeConstraints { (mk) in
      mk.left.right.equalToSuperview()
      mk.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    menuViewController.reloadData()
    contentViewController.reloadData()
    
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { (m) in
      m.centerY.equalTo(menuViewController.view)
      m.width.height.equalTo(44)
    }
  }
}

extension TopContainerViewController: PagingMenuViewControllerDataSource {
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

extension TopContainerViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    headerTitles.count
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    if let vc = viewControllerCache[headerTitles[index]] {
      return vc
    }else {
      let vc = SecondContainerViewController()
      viewControllerCache[headerTitles[index]] = vc
      return vc
    }
  }
}

extension TopContainerViewController: PagingMenuViewControllerDelegate {
  func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
    contentViewController.scroll(to: page, animated: true)
  }
}

extension TopContainerViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
    menuViewController.scroll(index: index, percent: percent, animated: false)
  }
}
