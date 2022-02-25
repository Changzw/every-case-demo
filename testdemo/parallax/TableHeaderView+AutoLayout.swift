//
//  TableHeaderView+AutoLayout.swift
//  TableHeaderViewWithAutoLayout
//
//  Created by 常仲伟 on 2021/4/20.
//  Copyright © 2021 czw. All rights reserved.
//

import UIKit

extension UITableView {
  func setTableHeaderView(_ headerView: UIView) {
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    tableHeaderView = headerView
//    let h = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//    headerView.setNeedsLayout()
//    headerView.layoutIfNeeded()
//    headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//    headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//    headerView.heightAnchor.constraint(equalToConstant: h).isActive = true
//    headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
  }
  
  func updateHeaderViewFrame() {
//    guard let headerView = tableHeaderView else { return }
//    headerView.layoutIfNeeded()
//    let header = tableHeaderView
//    tableHeaderView = header
  }
}
