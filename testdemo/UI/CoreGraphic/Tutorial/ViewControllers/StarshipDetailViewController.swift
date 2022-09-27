/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class StarshipDetailViewController: UITableViewController {
  var starship: Starship? {
    didSet {
      populateTableItems()
    }
  }
  var tableItems: [StarshipDetailTableItem] = []

  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.roundingMode = .halfDown
    return formatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
  }
}

extension StarshipDetailViewController {
  func populateTableItems() {
    tableItems = []
    guard let starship = self.starship else {
      return
    }

    if let image = starship.image {
      tableItems.append(.image(image))
    }
    tableItems.append(.field("Model", starship.model))
    tableItems.append(.field("Class", starship.starshipClass))

    if let costInCredits = starship.costInCredits,
    let formattedCost = numberFormatter.string(from: NSNumber(value: costInCredits)) {
      tableItems.append(.field("Cost in Credits", formattedCost))
  } else {
    tableItems.append(.field("Cost in Credits", "Unknown"))
  }

    if let capacity = starship.cargoCapacity,
    let formattedCapacity = numberFormatter.string(from: NSNumber(value: capacity)) {
      tableItems.append(.field("Cargo Capacity", "\(formattedCapacity) kg"))
    } else {
      tableItems.append(.field("Cargo Capacity", "Unknown"))
    }

    if let mglt = starship.MGLT {
      tableItems.append(.field("Speed", "\(mglt) megalights"))
    } else {
      tableItems.append(.field("Speed", "Unknown"))
    }

    if let aSpeed = starship.maxAtmospheringSpeed {
      tableItems.append(.field("Max Atmosphering Speed", "\(aSpeed)"))
    } else {
      tableItems.append(.field("Max Atmosphering Speed", "Not Applicable"))
    }

    if let length = numberFormatter.string(from: NSNumber(value: starship.length)) {
      tableItems.append(.field("Length", "\(length)"))
    } else {
      tableItems.append(.field("Length", "Unknown"))
    }

    tableView.reloadData()
  }
}

extension StarshipDetailViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableItems.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    starship?.name
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = tableItems[indexPath.row]

    switch item {
    case .image(let image):
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "ImageCell", for: indexPath) as? StarshipImageCell else {
        return UITableViewCell()
      }
      cell.starshipImageView.image = image
      return cell

    case let .field(title, subtitle):
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "FieldCell", for: indexPath) as? StarshipFieldCell else {
        return UITableViewCell()
      }
      cell.textLabel?.text = title
      cell.detailTextLabel?.text = subtitle
      return cell
    }
  }
}
