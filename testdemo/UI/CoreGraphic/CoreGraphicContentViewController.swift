//
//  CoreGraphicContentViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/9.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import XCoordinator

enum CoreGraphicRoute: Route, CaseIterable {
  case content
  case Lines_Rectangles_Gradients
}

final class CoreGraphicCoordinator: NavigationCoordinator<CoreGraphicRoute> {
  
  init() {
    super.init(initialRoute: .content)
  }
  
  override func prepareTransition(for route: CoreGraphicRoute) -> NavigationTransition {
    switch route {
    case .Lines_Rectangles_Gradients:
      return .push(StarshipsViewController())
    case .content:
      return .show(CoreGraphicContentViewController(route: unownedRouter))
    }
  }
}

class CoreGraphicContentViewController: UITableViewController {
  let route: UnownedRouter<CoreGraphicRoute>
  init(route: UnownedRouter<CoreGraphicRoute>) {
    self.route = route
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    CoreGraphicRoute.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    c.textLabel?.text = "\(CoreGraphicRoute.allCases[indexPath.row])"
    return c
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    route.trigger(CoreGraphicRoute.allCases[indexPath.row])
  }
}
