//
//  PagingListViewModel.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/26.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa
import RxDataSources

enum RecentItem {
  case artist(Artist)
  case album(Album)
}

typealias RecentItemRsp = [RecentItem]

struct Album {
  var title: String
}

struct Artist {
  var name: String
}

final class PagingListViewModel: ViewModel {
  private(set) var pageInfo = PageInfo(pageSize: 20)
  @BehaviorRelayed(wrappedValue: [])
  private(set) var items: [RecentItem]
  
  private(set) lazy var reloadAllData = Action<Void, RecentItemRsp> {
    self.pageInfo.reset()
    return self.mockData
  }
  
  private(set) lazy var loadMoreData = Action<Void, RecentItemRsp> {
    return self.mockData
  }
  
  var errorInfo: ((String)->())?
  
  var mockData: Observable<RecentItemRsp> {
    Observable<RecentItemRsp>.create { sink in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        sink.onNext(recentItems)
        sink.onCompleted()
      }
      
      return Disposables.create()
    }
  }
  
  override init() {
    super.init()
    reloadAllData.elements
      .bind(to: $items)
      .disposed(by: rx.disposeBag)
    
    loadMoreData.elements
      .map{[weak self] in
        guard let self = self else { return []}
        return self.items + $0
      }
      .bind(to: $items)
      .disposed(by: rx.disposeBag)
  }
}
