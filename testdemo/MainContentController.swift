//
//  MainContentController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/10/18.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Action
import XCoordinator
protocol ViewControllerMaker { }
extension ViewControllerMaker {
  var viewController: UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = .white
    return vc
  }
}

class MainContentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let button = UIButton()
  let router: UnownedRouter<MainRoute>
  let items = MainRoute.allCases[1...]
  
  lazy var tableView = UITableView().then {
    $0.delegate = self
    $0.dataSource = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  init(router: UnownedRouter<MainRoute>) {
    self.router = router
//    router.trigger(.animationContent)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(tableView)
    let swi = UISwitch()
    button.setTitle("WWWWWW", for: .normal)
    swi.frame = CGRect(x: 100, y: 100, width: 20, height: 20)
    swi.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int { 1 }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.textLabel?.text = "\(items[indexPath.row+1])"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let type = items[indexPath.row+1]
    router.trigger(type)
  }
}
