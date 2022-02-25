//
//  StickyMenuItemViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/4/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

enum StickyMenuItemDragDirection {
  case up, down
}

protocol StickyMenuItemViewControllerDelegate: class {
  var currentHeaderTop: CGFloat { get }
  var headerTopRange: Range<CGFloat> { get }
  func itemViewDidScroll(withDistance scrollDistance: CGFloat)
  func itemViewScrollEnded(withScrollDirection direction: StickyMenuItemDragDirection)
}

final class StickyMenuItemViewController: UIViewController {
  let tableView = UITableView()
  weak var delegate: StickyMenuItemViewControllerDelegate?
  private var dragDirection: StickyMenuItemDragDirection = .down
  private var prevContentOffset: CGPoint = .zero
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 44
  }
  
  func setupBinding() {
    
  }
}

extension StickyMenuItemViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
    cell.textLabel?.text = "\(indexPath.row + 1)"
    return cell
  }
}

extension StickyMenuItemViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let currentHeaderTop = delegate?.currentHeaderTop,
          let headerUpperBound = delegate?.headerTopRange.upperBound,
          let headerLowerBound = delegate?.headerTopRange.lowerBound else {
      prevContentOffset = scrollView.contentOffset
      return
    }
    
    let delta = scrollView.contentOffset.y - prevContentOffset.y
    if delta > 0,
       currentHeaderTop > headerLowerBound,
       scrollView.contentOffset.y > 0 {
      
      dragDirection = .up
      delegate?.itemViewDidScroll(withDistance: delta)
      scrollView.contentOffset.y -= delta
    }
    
    if delta < 0,
       currentHeaderTop < headerUpperBound,
       scrollView.contentOffset.y < 0 {
      
      dragDirection = .down
      delegate?.itemViewDidScroll(withDistance: delta)
      scrollView.contentOffset.y -= delta
    }

    prevContentOffset = scrollView.contentOffset
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y <= 0 {
      delegate?.itemViewScrollEnded(withScrollDirection: dragDirection)
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if decelerate == false && scrollView.contentOffset.y <= 0 {
      delegate?.itemViewScrollEnded(withScrollDirection: dragDirection)
    }
  }
}
