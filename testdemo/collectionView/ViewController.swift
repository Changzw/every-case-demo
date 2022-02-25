//
//  ViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/10/15.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class ViewController: UIViewController {
  let tableView = UITableView()
  
  let btn = UIButton(type: .system)
  let v = UIView()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 44, height: 44)
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = 5
    let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
    c.showsHorizontalScrollIndicator = false
    c.showsVerticalScrollIndicator = false
    c.bounces = false
    c.delegate = self
    c.dataSource = self
    return c
  }()
  
//  var timer = Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler())
  let dataChange = BehaviorRelay<String>(value: "")
  
  var needData: Observable<String> {
    .empty()
//    dataChange.skip(1)
//      .flatMapLatest {[weak self] (info) -> Observable<String> in
//      guard let self = self else {return .empty()}
//      return self.timer.map{ v in
//        return info + String(v)
//      }
//    }
  }
  
  let actionButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("action", for: .normal)
    return b
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.frame = view.bounds
    
    needData.subscribe(onNext: { (info) in
      print(info)
    })
    
    btn.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysOriginal), for: .normal)
    btn.setTitle("11111", for: .normal)
    view.backgroundColor = .black
    view.addSubview(btn)
    btn.snp.makeConstraints { (m) in
      m.top.equalTo(view).offset(100)
      m.left.equalTo(view).offset(30)
    }
    
    view.addSubview(actionButton)
    actionButton.snp.makeConstraints { (m) in
      m.top.equalTo(view).offset(100)
      m.right.equalTo(view).offset(-30)
    }

    view.backgroundColor = .white
    view.addSubview(v)
    v.isUserInteractionEnabled = false
    v.snp.makeConstraints{ $0.edges.equalTo(view) }
    v.backgroundColor = .random
    btn.addTarget(self, action: #selector(click), for: .touchUpInside)
    
    view.addSubview(collectionView)
    collectionView.backgroundColor = .white
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.snp.makeConstraints { (m) in
      m.left.equalToSuperview()
      m.centerY.equalToSuperview()
      m.size.equalTo(CGSize(width: 300, height: 45))
    }
    
    let action = Action<Int, Int>(workFactory: { v in
      print("\(Self.a)------")
      Self.a += 1
      return Observable<Int>.timer(3, scheduler: MainScheduler.instance)
        .take(1)
        .map { _ in
          Self.a
        }
    })
    
    actionButton.rx.bind(to: action, input: 5)
    action.elements
      .debounce(1, scheduler: MainScheduler.instance)
      .throttle(2, scheduler: MainScheduler.instance)
      .bind{
        print("output: \($0)")
      }
      .disposed(by: rx.disposeBag)
  }
  
  static var a: Int = 0
  
  var index = 0
  let data = [
  "aaaa",
  "bbbb",
  "cccc",
  "dddd",
  "eeee",
  "ffff",]
  
  deinit {
    actionButton.rx.unbindAction()
  }
  
  @objc func click(){
    v.removeFromSuperview()
    dataChange.accept(data[index])
    index = (index + 1) % data.count
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    100
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.contentView.backgroundColor = .random
    cell.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    cell.contentView.clipsToBounds = true
    cell.contentView.layer.cornerRadius = 22
    return cell
  }
  
  
}
