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

import Foundation
import UIKit

struct Starship: Decodable {
  let name: String
  let model: String
  let starshipClass: String
  let costInCredits: Float?
  let cargoCapacity: Float?
  let MGLT: Int?
  let maxAtmospheringSpeed: Int?
  let length: Float
}

extension Starship {
  var image: UIImage? {
    let imageName = name.lowercased().replacingOccurrences(of: " ", with: "_")
    return UIImage(named: imageName)
  }
}

// The data stored in Starship.json is a lightly modified response from the Star Wars API example from GraphQL - https://graphql.org/swapi-graphql
// Full query: https://goo.gl/ngGGFA
extension Starship {
  static var all: [Starship] {
    guard let url = Bundle.main.url(forResource: "Starships", withExtension: "json") else {
      return []
    }
    do {
      let data = try Data(contentsOf: url)
      let response = try JSONDecoder().decode(Response.self, from: data)
      return response.allStarships.compactMap { $0["node"] }
    } catch {
      print("Could not decode starship data from JSON")
      print(error)
      return []
    }
  }
}

private extension Starship {
  struct Response: Decodable {
    let allStarships: [[String: Starship]]
  }
}
