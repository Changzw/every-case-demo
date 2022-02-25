//
//  GenericTableViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/10/25.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

// type erasure
struct CellConfigurator {
  let cellClass: UITableViewCell.Type
  let reuseIdentifier: String
  let configure: (UITableViewCell) -> ()
  
  init<Cell: UITableViewCell>(reuseIdentifier: @autoclosure () -> String = Cell.self.description(),
                              configure: @escaping (Cell) -> ()) {
    self.cellClass = Cell.self
    self.reuseIdentifier = reuseIdentifier()
    self.configure = { cell in
      guard let c = cell as? Cell else {
        print("error: type \(cell.description), generic type: \(Cell.description())")
        return
      }
      configure(c)
    }
  }
}

final class GenericTableViewController<Item>: UITableViewController {
  @BehaviorRelayed<[Item]>(wrappedValue: [])
  var items
  let cellConfigurator: (Item) -> CellConfigurator
  var didSelect: (Item) -> () = { _ in }
  var reuseIdentifiers: Set<String> = []
  
  init(items: [Item], cellConfigurator: @escaping (Item) -> CellConfigurator) {
    self.cellConfigurator = cellConfigurator
    super.init(style: .plain)
    self.items = items
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    didSelect(item)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let descriptor = cellConfigurator(item)
    
    if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
      tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
      reuseIdentifiers.insert(descriptor.reuseIdentifier)
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
    descriptor.configure(cell)
    return cell
  }
}

final class ArtistCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class AlbumCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value2, reuseIdentifier: reuseIdentifier)
  }
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

let artists: [Artist] = [
  Artist(name: "Prince"),
  Artist(name: "Glen Hansard"),
  Artist(name: "I Am Oak")
]

let albums: [Album] = [
  Album(title: "Blue Lines"),
  Album(title: "Oasem"),
  Album(title: "Bon Iver")
]

let recentItems: [RecentItem] = [
  .artist(artists[0]),
  .artist(artists[1]),
  .album(albums[1])
]

extension Artist {
  func configureCell(_ cell: ArtistCell) {
    cell.textLabel?.text = name
  }
}

extension Album {
  func configureCell(_ cell: AlbumCell) {
    cell.textLabel?.text = title
  }
}

extension RecentItem {
  var cellConfigurator: CellConfigurator {
    switch self {
      case .artist(let artist):
        return CellConfigurator(reuseIdentifier: "artist", configure: artist.configureCell)
      case .album(let album):
        return CellConfigurator(reuseIdentifier: "album", configure: album.configureCell)
    }
  }
}


