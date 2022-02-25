//
//  CoreGraphicTableViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/30.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class CoreGraphicTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.textLabel?.text = "\(indexPath)"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.pushViewController(GradientShapeViewController(), animated: true)
  }
}
