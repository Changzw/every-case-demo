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

protocol ViewControllerMaker { }
extension ViewControllerMaker {
  var viewController: UIViewController {
    let vc = UIViewController()
    vc.view.backgroundColor = .white
    return vc
  }
}

class MainContentController: UITableViewController {
  let button = UIButton()
  override func viewDidLoad() {
    super.viewDidLoad()
    let swi = UISwitch()
    button.setTitle("WWWWWW", for: .normal)
    swi.frame = CGRect(x: 100, y: 100, width: 20, height: 20)
    swi.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int { 1 }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Chapter.allCases.count }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.textLabel?.text = "\(Chapter.allCases[indexPath.row])"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let type = Chapter.allCases[indexPath.row]
    origin1(type: type)
  }
  
  func origin0(type: Chapter) {
    navigationController?.pushViewController(type.viewController, animated: true)
  }
  
  func origin1(type: Chapter) {
    navigate(type)
  }
  
  func recursive(observable: Observable<Int>) -> Observable<Int> {
    observable.flatMap { value -> Observable<Int> in
      guard value < 10 else {
        return BehaviorRelay(value: -1).asObservable()
      }
      
      print(value)
      return self.recursive(observable: BehaviorRelay(value: value + 1).asObservable())
    }
  }
}
