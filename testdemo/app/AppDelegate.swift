//
//  AppDelegate.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/10/15.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Combine
import XCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var item = PublishSubject<Int>()
  
  private lazy var mainWindow = UIWindow()
  private let router = MainContentCoordinator().strongRouter

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    router.setRoot(for: mainWindow)
    return true
  }
}
