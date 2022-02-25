//
//  SecondContainerViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/7.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import PagingKit

class SecondContainerViewController: UIViewController {
  let headerTitles = ["今日累计", "近7日累计", "本月累计"]
  
  var viewControllerCache = [String: UIViewController]()
  
  private lazy var menuViewController: PagingMenuViewController = {
    let m = PagingMenuViewController()
    m.contentInset = .zero
    m.dataSource = self
    m.delegate = self
    m.register(type: OverlayMenuCell.self, forCellWithReuseIdentifier: "identifier")
    m.view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    let t = TitleOverlayerView()
    t.height = 28
    m.registerFocusView(view: t, isBehindCell: true)
    m.reloadData(with: 0, completionHandler: { [weak self] (vc) in
      (self?.menuViewController.currentFocusedCell as! OverlayMenuCell)
        .updateMask(animated: true)
    })
    m.view.backgroundColor = .white
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
    view.backgroundColor = .white
    menuViewController.willMove(toParent: self)
    addChild(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMove(toParent: self)
    
    menuViewController.view.snp.makeConstraints { (mk) in
      mk.centerX.equalToSuperview()
      mk.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      mk.height.equalTo(28)
      mk.width.equalTo(headerTitles.map({
        OverlayMenuCell
          .sizingCell
          .calculateWidth(from: 28, title: $0)
      }).reduce(0, +))
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
    menuViewController.view.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    menuViewController.view.layer.cornerRadius = menuViewController.view.bounds.midY
  }
}

extension SecondContainerViewController: PagingMenuViewControllerDataSource {
  func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
    let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! OverlayMenuCell
    cell.configure(title: headerTitles[index])
    cell.referencedFocusView = viewController.focusView
    cell.referencedMenuView = viewController.menuView
    cell.updateMask()
//    cell.hightlightTextColor = UIColor()
    return cell
  }
  
  func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
    return OverlayMenuCell
      .sizingCell
      .calculateWidth(from: viewController.view.bounds.height, title: headerTitles[index])
  }
  
  func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
    headerTitles.count
  }
}

extension SecondContainerViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    headerTitles.count
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    if let vc = viewControllerCache[headerTitles[index]] {
      return vc
    }else {
      let vc = ListViewController()
      viewControllerCache[headerTitles[index]] = vc
      return vc
    }
  }
}

extension SecondContainerViewController: PagingMenuViewControllerDelegate {
  func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
    contentViewController.scroll(to: page, animated: true)
  }
}

extension SecondContainerViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
    menuViewController.scroll(index: index, percent: percent, animated: false)
  }
}
