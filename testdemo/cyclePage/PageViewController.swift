//
//  PageViewController.swift
//  testDemo
//
//  Created by czw on 10/18/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit
import SnapKit

class PageViewController: UIViewController {
  
//  let page = CyclePageView(cellClass: UICollectionViewCell.self, scrollDirection: .horizontal)
  let pageControl = UIPageControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    view.backgroundColor = .white
//    view.addSubview(page)
//    page.snp.makeConstraints { (m) in
//      m.left.right.equalToSuperview()
//      m.height.equalTo(300)
//      m.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//    }
//    
//    view.addSubview(pageControl)
//    pageControl.snp.makeConstraints { (m) in
//      m.top.equalTo(page.snp.bottom).offset(5)
//      m.centerX.equalTo(page)
//      m.left.right.equalTo(page)
//      m.height.equalTo(20)
//    }
//    
//    page.register(UICollectionViewCell.self)
//    page.cellConfig = { cell, idx in
//      cell.backgroundColor = (self.page.items[idx] as! Item).c
//    }
//    
//    page.pageTo = { idx in
//      debugPrint("pageTo:\(idx)")
//      self.pageControl.currentPage = idx
//    }
//    
//    page.selectedAt = { idx in
//      debugPrint("selectAt:\(idx)")
//    }
//    
//    page.items = [
//      Item(),
//      Item(),
//      Item(),
//      Item(),
//    ]
//    pageControl.numberOfPages = page.items.count
//    pageControl.currentPage = 0
//    pageControl.pageIndicatorTintColor = .orange
//    pageControl.currentPageIndicatorTintColor = .red
  }
}

struct Item: CyclePageItem {
  let c = UIColor.random
}
