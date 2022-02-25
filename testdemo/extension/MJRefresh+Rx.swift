//
//  MJRefresh+Rx.swift
//  badamlive
//
//  Created by 常仲伟 on 2021/5/18.
//  Copyright © 2021 czw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
  var startedRefresh: ControlEvent<Void> {
    ControlEvent(events: Observable.create { [weak refresh = self.base] sink in
      if let c = refresh {
        c.refreshingBlock = {
          sink.on(.next(()))
        }
      }
      return Disposables.create()
    })
  }
}

enum RefreshAction {
  case startRefresh
  case stopRefresh
  
  case startLoadmore
  case stopLoadmore
  
  case showNomoreData
  case resetNomoreData
}

extension Reactive where Base: UIScrollView {
  var refreshAction: Binder<RefreshAction> {
    Binder(base) { (target, action) in
      switch action {
        case .startRefresh:
          guard let header = target.mj_header else { return }
          header.beginRefreshing()
        case .stopRefresh:
          guard let header = target.mj_header else { return }
          header.endRefreshing()
        case .startLoadmore:
          guard let footer = target.mj_footer else { return }
          footer.beginRefreshing()
        case .stopLoadmore:
          guard let footer = target.mj_footer else { return }
          footer.endRefreshing()
        case .showNomoreData:
          guard let footer = target.mj_footer else { return }
          footer.endRefreshingWithNoMoreData()
        case .resetNomoreData:
          guard let footer = target.mj_footer else { return }
          footer.resetNoMoreData()
      }
    }
  }
}
