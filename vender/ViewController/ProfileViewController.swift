//
//  ProfileViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/16.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  let person: Person
  init(person: Person) {
    self.person = person
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}
