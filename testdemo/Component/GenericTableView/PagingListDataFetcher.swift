//
//  PagingListDataFetcher.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/26.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import Foundation
import Action
import RxSwift

final class PagingListDataFetcher<Item> {
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
  
  private let bag = DisposeBag()
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
  
  private let reloadAllObservable: Observable<Item>
  private let loadMoreObservable: Observable<Item>
  
  init(reloadAllObservable: Observable<Item>,
       loadMoreObservable: Observable<Item>) {
    self.reloadAllObservable = reloadAllObservable
    self.loadMoreObservable = loadMoreObservable
    reloadAllData.elements
      .bind(to: $items)
      .disposed(by: bag)
    
    loadMoreData.elements
//      .map{[weak self] in -> [Item]
//        guard let self = self else { return []}
//        return self.items + $0
//      }
      .bind(to: $items)
      .disposed(by: bag)
  }
}
