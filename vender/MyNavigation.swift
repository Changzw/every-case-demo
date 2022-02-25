//
//  MyNavigation.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/16.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import Foundation

struct Person {
  let name: String
  let age: Int
}

enum MyNavigation: Navigation {
  case about
  case profile(person: Person)
}

