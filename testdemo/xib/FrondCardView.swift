//
//  FrondCardView.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/20.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
  
  @IBOutlet var imageView: FrondCardImageView!
  override func layoutSubviews() {
    super.layoutSubviews()
    roundedCorner()
  }
}

final class FrontCardView: CardView {
  
}

@IBDesignable
final class FrondCardImageView: UIImageView {
  @IBInspectable
  var maskImage: UIImage! {
    didSet { mask = UIImageView(image: maskImage) }
  }
  
}
