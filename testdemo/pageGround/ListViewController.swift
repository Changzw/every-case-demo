//
//  ListViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/1/7.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.description())
    tableView.snp.makeConstraints{ $0.edges.equalToSuperview() }
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ListItemCell.description(), for: indexPath)
    cell.textLabel?.text = String(indexPath.row)
    return cell
  }
}
