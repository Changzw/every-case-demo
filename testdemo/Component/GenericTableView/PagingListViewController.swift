//
//  PagingListViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/25.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import RxCocoa
import RxRelay

final class PagingListViewController: UIViewController {
  
  lazy var tableView: PagingListView<RecentItem> = {
    let t = PagingListView<RecentItem>(cellConfigurator: { $0.cellConfigurator })
    t.mj_header = MJRefreshGifHeader()
    t.mj_footer = MJRefreshBackNormalFooter()
    return t
  }()
  
  let viewModel: PagingListViewModel
  init(viewModel: PagingListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupInputBinding()
    setupOutputBinding()
  }

  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(tableView)
    tableView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupInputBinding() {
    // event from viewmodel
    viewModel.reloadAllData.errors
      .map{ _ in RefreshAction.stopRefresh }
      .bind(to: tableView.rx.refreshAction)
      .disposed(by: rx.disposeBag)
    
    viewModel.reloadAllData.executionObservables
      .map{ _ in RefreshAction.stopRefresh }
      .bind(to: tableView.rx.refreshAction)
      .disposed(by: rx.disposeBag)
    
    viewModel.loadMoreData.errors
      .map{ _ in RefreshAction.stopLoadmore }
      .bind(to: tableView.rx.refreshAction)
      .disposed(by: rx.disposeBag)
    
    viewModel.loadMoreData.executionObservables
      .map{ _ in RefreshAction.stopLoadmore }
      .bind(to: tableView.rx.refreshAction)
      .disposed(by: rx.disposeBag)
    
    viewModel.$items
      .bind(to: tableView.rx.items) { (tableView, row, element) in
        guard let pagingListView = tableView as? PagingListView<RecentItem> else { return UITableViewCell() }
        let c = pagingListView.cellConfigurator(element)
        pagingListView.registerIfNeed(c.reuseIdentifier, cellClass: c.cellClass)
        let cell = tableView.dequeueReusableCell(withIdentifier: c.reuseIdentifier)!
        c.configure(cell)
        return cell
      }
      .disposed(by: rx.disposeBag)
    
    // start refreshing
    Observable.just(RefreshAction.startRefresh)
      .bind(to: tableView.rx.refreshAction)
      .disposed(by: rx.disposeBag)
  }
  
  private func setupOutputBinding() {
    // event to viewModel
    tableView.mj_header?.rx.startedRefresh
      .bind(to: viewModel.reloadAllData.inputs)
      .disposed(by: rx.disposeBag)
    
    tableView.mj_footer?.rx.startedRefresh
      .bind(to: viewModel.loadMoreData.inputs)
      .disposed(by: rx.disposeBag)
  }
}
