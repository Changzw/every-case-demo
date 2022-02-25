//
//  CustomTransition__ViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/18.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

class CustomTransition__ViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.textLabel?.text = "\([indexPath.row])"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
      case 0:
        present(TFristViewController(), animated: true, completion: nil)
      default:
        break
    }
  }
}
