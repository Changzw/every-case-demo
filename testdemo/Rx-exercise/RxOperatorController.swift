//
//  RxOperatorController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/10/18.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
import RxSwift
import FSPagerView

class RxOperatorController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .random
    
    return
    let single0 = Single<Int>.create { (subscriber) -> Disposable in
      
      return Disposables.create {
        debugPrint("-----0")
      }
    }
    let single1 = Single<Int>.create { (subscriber) -> Disposable in
      
      return Disposables.create {
        debugPrint("-----1")
      }
    }
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int { 0 }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
    return cell
  }
}
