//
//  ParallaxViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/3/23.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import PagingKit

final class HeaderView: UITableViewHeaderFooterView {
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class ParallaxViewController: UIViewController {
  let topView = UIView()
  let tableView = UITableView()
  
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

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  private func setupBinding() {
    menuViewController.reloadData()
    contentViewController.reloadData()
  }
  
  private func setupUI(){
    let l = UILabel()
    l.text = "ad;lskfjas;dlfkjas;lgkjasd;lfkjad;lfkjasd;lfjka;lgkjasd;lfkja;sdlkfja;lsdfhhb;kl"
    l.numberOfLines = 0
    l.preferredMaxLayoutWidth = view.bounds.width
    topView.addSubview(l)
    l.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    topView.translatesAutoresizingMaskIntoConstraints = false
    topView.setNeedsLayout()
    topView.layoutIfNeeded()
    tableView.tableHeaderView = topView

    view.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.description())
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
  }
}

extension ParallaxViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.description())
    if menuViewController.parent == nil {
      addChild(menuViewController)
    }
    h?.contentView.addSubview(menuViewController.view)
    menuViewController.view.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    menuViewController.view.backgroundColor = .orange
    return h
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    44
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UIScreen.main.bounds.height - topView.bounds.height - self.tableView(tableView, heightForHeaderInSection: indexPath.section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    contentViewController.willMove(toParent: self)
    addChild(contentViewController)
    cell.contentView.addSubview(contentViewController.view)
    contentViewController.didMove(toParent: self)
    contentViewController.view.snp.makeConstraints { (mk) in
      mk.edges.equalToSuperview()
    }
    return cell
  }
}

extension ParallaxViewController: PagingMenuViewControllerDataSource {
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

extension ParallaxViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    headerTitles.count
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    if let vc = viewControllerCache[headerTitles[index]] {
      return vc
    }else {
      let vc = index == 0 ? SecondContainerViewController() : SecondMenuContainerViewController()
      viewControllerCache[headerTitles[index]] = vc
      return vc
    }
  }
}

extension ParallaxViewController: PagingMenuViewControllerDelegate {
  func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
    contentViewController.scroll(to: page, animated: true)
  }
}

extension ParallaxViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
    menuViewController.scroll(index: index, percent: percent, animated: false)
  }
}
