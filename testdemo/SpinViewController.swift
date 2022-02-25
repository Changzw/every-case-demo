//
//  SpinViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/4/20.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class SpinViewController: UIViewController {

  let spinView = SpinView()
  let imageView = UIImageView(image: UIImage(named: "00000"))
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(spinView)
    spinView.snp.makeConstraints{
      $0.width.height.equalTo(100)
      $0.center.equalToSuperview()
    }
    spinView.primaryView.backgroundColor = .red
    spinView.secondaryView.backgroundColor = .green
    //    view.addSubview(tableView)
    //    tableView.snp.makeConstraints{
    //      $0.edges.equalToSuperview()
    //    }
    //
    //    tableView.insertSubview(imageView, at: 0)
    //
    //    view.backgroundColor = .white
  }
}
