//
//  PagingList.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/27.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import Foundation
import RxSwift

class PagingList<Item> {
  let tableView: PagingListView<Item>
  let fetcher: PagingListDataFetcher<Item>
  
  init(cellConfigurator: @escaping (Item) -> CellConfigurator,
       reloadAllObservable: Observable<Item>,
       loadMoreObservable: Observable<Item>) {
    tableView = PagingListView(cellConfigurator: cellConfigurator)
    fetcher = PagingListDataFetcher(reloadAllObservable: reloadAllObservable, loadMoreObservable: loadMoreObservable)
  }
}
