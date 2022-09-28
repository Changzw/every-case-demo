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
import PagingKit

class SegmentViewController: UIViewController {
  private let seg = AutoLayoutSegmentView(selectedIndex: 3)
  var viewControllers = [UIViewController]()
  
  private lazy var contentViewController: PagingContentViewController = {
    let c = PagingContentViewController()
    if let pan = navigationController?.interactivePopGestureRecognizer {
      c.scrollView.panGestureRecognizer.require(toFail: pan)
    }
    c.dataSource = self
    c.delegate = self
    c.scrollView.bounces = false
    return c
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(seg)
    seg.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.height.equalTo(44)
    }
    for _ in 0..<seg.items.count {
      let vc = UIViewController()
      vc.view.backgroundColor = .random
      viewControllers.append(vc)
    }
    
    contentViewController.willMove(toParent: self)
    addChild(contentViewController)
    view.addSubview(contentViewController.view)
    contentViewController.didMove(toParent: self)
    contentViewController.view.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(seg.snp.bottom)
    }
    contentViewController.didMove(toParent: self)
    
    contentViewController.reloadData(with: 3, completion: nil)
    seg.didSelectedIndex = {[unowned self] in
      self.contentViewController.scroll(to: $0, animated: true)
    }
  }
}


extension SegmentViewController: PagingContentViewControllerDataSource {
  func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
    seg.items.count
  }
  
  func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
    viewControllers[index]
  }
}

extension SegmentViewController: PagingContentViewControllerDelegate {
  func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
//    seg.move(index: index, percent: percent)
//    print("percent:\(percent)")
  }
  func contentViewController(viewController: PagingContentViewController, willBeginManualScrollOn index: Int) {
    
  }
  func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int) {
    print("didEndManualScrollOn:\(index)")
  }
  func contentViewController(viewController: PagingContentViewController, willBeginPagingAt index: Int, animated: Bool) {
    
  }
  func contentViewController(viewController: PagingContentViewController, willFinishPagingAt index: Int, animated: Bool) {
    
  }
  func contentViewController(viewController: PagingContentViewController, didFinishPagingAt index: Int, animated: Bool) {
    print("didFinishPagingAt:\(index)")
    seg.selectedIndex = index
  }
}
