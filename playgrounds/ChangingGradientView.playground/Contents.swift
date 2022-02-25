//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

extension UIColor {
  
  convenience init(AHEX string: String) {
    var hex = string.hasPrefix("#")
      ? String(string.dropFirst())
      : string
    guard hex.count == 8 || hex.count == 6
    else {
      self.init(white: 1.0, alpha: 1)
      return
    }
    if hex.count == 6 {
      hex = "FF" + hex
    }
    guard let intCode = Int(hex, radix: 16) else {
      self.init(white: 1.0, alpha: 1)
      return
    }
    
    let divisor: CGFloat = 255
    let alpha     = CGFloat((intCode >> 24) & 0xFF) / divisor
    let red       = CGFloat((intCode >> 16) & 0xFF) / divisor
    let green     = CGFloat((intCode >> 8 ) & 0xFF) / divisor
    let blue      = CGFloat((intCode      ) & 0xFF) / divisor
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

class MyViewController : UIViewController {
  var timer: DispatchSourceTimer?
  let gradientLayer = CAGradientLayer()
  override func loadView() {
    super.loadView()
    let view = UIView()
    gradientLayer.startPoint = .zero
    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    gradientLayer.colors = [UIColor(AHEX: "#\(String(Int.random(in: 0...255), radix: 16))"),
                            UIColor(AHEX: "#\(String(Int.random(in: 0...255), radix: 16))")].map(\.cgColor)

    self.view = view
    
    timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
    timer?.setEventHandler { [weak self] in
      guard let self = self else { return }
      self.gradientLayer.colors = [UIColor(AHEX: "#\(String(Int.random(in: 0...255), radix: 16))"),
                              UIColor(AHEX: "#\(String(Int.random(in: 0...255), radix: 16))")].map(\.cgColor)
    }
    timer?.schedule(deadline: .now() + .seconds(1), repeating: .seconds(1))
    timer?.activate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.addSublayer(gradientLayer)
  }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

