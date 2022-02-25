//
//  PagingListView.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/25.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import RxCocoa

final class PagingListView<Item>: UITableView {

  let cellConfigurator: (Item) -> CellConfigurator
  var didSelect: (Item) -> () = { _ in }
  var allReuseIdentifiers: Set<String> = []
  private var reuseIdentifiers = Set<String>()
  init(cellConfigurator: @escaping (Item) -> CellConfigurator) {
    self.cellConfigurator = cellConfigurator
    super.init(frame: .zero, style: .plain)
  }
  
  func registerIfNeed(_ reuseIdentifier: String, cellClass: UITableViewCell.Type) {
    if !allReuseIdentifiers.contains(reuseIdentifier) {
      register(cellClass, forCellReuseIdentifier: reuseIdentifier)
      allReuseIdentifiers.insert(reuseIdentifier)
    }
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
