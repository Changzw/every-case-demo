//
//  DifferenceViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/10/19.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
import DifferenceKit

enum Section: CaseIterable, Differentiable {
  case banner,online,offlineTitle,offline
}
enum CellItem: Differentiable {
  var differenceIdentifier: String {
    switch self {
      case .banner: return "banner"
      case .online(let r): return String(r)
      case .offline(let r): return String(r)
      case .offlineTitle(let t): return t
    }
  }
  
  case banner(String)
  case online(Int)
  case offlineTitle(String)
  case offline(Int)
  
  func isContentEqual(to source: CellItem) -> Bool {
    switch (self, source) {
      case let (.banner(a0), .banner(a1)): return a0 == a1
      case let (.online(a0), .online(a1)): return a0 == a1
      case let (.offline(a0), .offline(a1)): return a0 == a1
      case let (.offlineTitle(a0), .offlineTitle(a1)): return a0 == a1
      default: return false
    }
  }
}

class DifferenceViewController: UIViewController {
  let tableView: UITableView = UITableView()
  
  var data: [ArraySection<Section, CellItem>] = []
  var dataInput: [ArraySection<Section, CellItem>] {
    get { return data }
    set {
      let changeset = StagedChangeset(source: data, target: newValue)
      tableView.reload(using: changeset, with: .none, setData: { (c) in
        self.data = c
      })
    }
  }
  
  @objc func add() {
    var newdata: [ArraySection<Section, CellItem>] = []
    for var s in data {
      switch s.model {
        case .banner:
          s.elements = [CellItem.banner("4444")]
          newdata += [s]
        case .online:
          s.elements.insert(contentsOf: [21,22,23,24].map{ CellItem.online($0) }, at: 0)
          newdata += [s]
        case .offlineTitle:
          s.elements = [CellItem.offlineTitle("5555")]
          newdata += [s]
        case .offline:
          s.elements.insert(contentsOf: [621,622,623,624].map{ CellItem.online($0) }, at: 0)
          newdata += [s]
      }
    }
    dataInput = newdata
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    tableView.frame = view.bounds
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.dataInput =
        [ArraySection(model: .banner, elements: [.banner("233")]),
         ArraySection(model: .online, elements: [1,2,3,4,5,6,7,8,9].map{ CellItem.online($0) }),
         ArraySection(model: .offlineTitle, elements: [.offlineTitle("offlineTitle")]),
         ArraySection(model: .offline, elements: [11,12,13,14,15,16,17,18,19].map{ CellItem.offline($0) }),]
    }
  }
}

extension DifferenceViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.pushViewController(PageViewController(), animated: true)
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data[section].elements.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    let elm = data[indexPath.section].elements[indexPath.row]
    switch elm {
      case let .banner(d):
        cell.textLabel?.text = "banner:" + d
        cell.contentView.backgroundColor = .red
      case let .online(d):
        cell.textLabel?.text = "online:" + String(d)
        cell.contentView.backgroundColor = .yellow
      case let .offlineTitle(d):
        cell.textLabel?.text = "offlineTitle:" + d
        cell.contentView.backgroundColor = .blue
      case let .offline(d):
        cell.textLabel?.text = "offline:" + String(d)
        cell.contentView.backgroundColor = .orange
    }
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }
}
