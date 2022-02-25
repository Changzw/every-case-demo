//
//  Notification.swift
//  badamlive
//
//  Created by czw on 9/15/20.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

//MARK: - system
extension Notification.Name {
  static let pushingLive = Notification.Name("com.ziipin.badamlive.user.pushingLive")
  static let userlogin = Notification.Name("com.ziipin.badamlive.user.login")
  static let userlogout = Notification.Name("com.ziipin.badamlive.user.logout")
  static let userInfoDidChanged = Notification.Name("com.ziipin.badamlive.user.infoChange")
  static let followDidChange = Notification.Name("com.ziipin.badamlive.user.followDidChange")
  static let updateDiamonds = Notification.Name("com.ziipin.badamlive.updateDiamonds")
  static let languageDidChanged = Notification.Name("com.ziipin.badamlive.system.languageChange")
  static let SKPaymentTransactionDidPurchase = Notification.Name("com.ziipin.badamlive.system.SKPaymentTransactionDidPurchase")
  static let repeatClickTabBarButton = Notification.Name("com.ziipin.badamlive.system.repeatClickTabBarButton")
  static let didUpdateOfficialMessageStatus = Notification.Name("com.ziipin.badamlive.system.didUpdateOfficialMessageStatus")
  
  // 礼物相关
  static let didUpdateFreeGift = Notification.Name("com.ziipin.badamlive.Gift.didUpdateFreeGift")
  static let didUpdateQuickGift = Notification.Name("com.ziipin.badamlive.Gift.didUpdateQuickGift")
  static let didUpdatePacketGift = Notification.Name("com.ziipin.badamlive.Gift.didUpdatePacketGift")
}

//MARK: - UI
extension Notification.Name {
  static let liveWeakNet = Notification.Name("com.ziipin.badamlive.live.weaknet")
}

//MARK: - Revenue
extension Notification.Name {
  static let liverWithDrawMoney = Notification.Name("com.ziipin.badamlive.live.liverWithDrawMoney")
}

//MARK: - LiveRoom
extension Notification.Name {
  static let showUserCard = Notification.Name("com.ziipin.badamlive.live.showUserCard")
}

extension String {
  fileprivate static let isCancelFollowKey = "com.ziipin.badamlive.isCancelFollowKey" 
  fileprivate static let liveFreeGiftKey = "com.ziipin.badamlive.liveFreeGiftKey"
  fileprivate static let liveQuickGiftKey = "com.ziipin.badamlive.liveQuickGiftKey"
  fileprivate static let livePacketGiftsKey = "com.ziipin.badamlive.livePacketGiftsKey"
}

extension NotificationCenter {
  func postFollowChangeNotification(object: Any? = nil, isCancel: Bool) {
    post(name: .followDidChange, object: object, userInfo: [String.isCancelFollowKey: isCancel])
  }
  
  func addObserverForFollowChange(_ observer: Any, selector: Selector, object: Any? = nil) {
    addObserver(observer, selector: selector, name: .followDidChange, object: object)
  }
}
