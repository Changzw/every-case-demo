//
//  AnimationContentViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/5.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import XCoordinator

final class AnimationContentViewController: UIViewController {
  var router: UnownedRouter<AnimationRoute>?
  
  let tableView = UITableView().then {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
  }
}

extension AnimationContentViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    AnimationChapter.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.textLabel?.text = "\(AnimationChapter.allCases[indexPath.row])"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let type = AnimationChapter.allCases[indexPath.row]
    switch type {
    case .animation:
      router?.trigger(.test)
//      navigationController?.pushViewController(AnimationViewController(), animated: true)
    }
  }
}
