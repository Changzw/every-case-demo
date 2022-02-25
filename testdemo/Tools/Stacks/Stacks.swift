// The MIT License (MIT)
//
// Copyright (c) 2021 Alexander Grebenyuk (github.com/kean).

import UIKit

public extension UIView {
  @objc(vStackWithAlignment:distribution:spacing:margins:views:)
  static func vStack(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill,
    spacing: CGFloat = 0,
    margins: UIEdgeInsets = .zero,
    _ views: [UIView]
  ) -> UIStackView {
    makeStackView(axis: .vertical, alignment: alignment, distribution: distribution, spacing: spacing, margins: margins, views)
  }
  
  @objc(hStackWithAlignment:distribution:spacing:margins:views:)
  static func hStack(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill,
    spacing: CGFloat = 0,
    margins: UIEdgeInsets = .zero,
    _ views: [UIView]
  ) -> UIStackView {
    makeStackView(axis: .horizontal, alignment: alignment, distribution: distribution, spacing: spacing, margins: margins, views)
  }
}

// objc
public extension UIView {
  @available(swift, obsoleted: 3.1)
  @objc(vStackWithSpacing:margins:views:)
  static func vStack(
    spacing: CGFloat = 0,
    margins: UIEdgeInsets = .zero,
    _ views: [UIView]
  ) -> UIStackView {
    makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: spacing, margins: margins, views)
  }
  
  @available(swift, obsoleted: 3.1)
  @objc(hStackWithSpacing:margins:views:)
  static func hStack(
    spacing: CGFloat = 0,
    margins: UIEdgeInsets = .zero,
    _ views: [UIView]
  ) -> UIStackView {
    makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: spacing, margins: margins, views)
  }
}

extension UIView {
  /// Makes a fixed space along the axis of the containing stack view.
  static func spacer(_ value: SpacerValue) -> UIView {
    Spacer(value: value)
  }
}

// MARK: - Private

private extension UIView {
  static func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, margins: UIEdgeInsets, _ views: [UIView]) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: views)
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = axis
    stack.alignment = alignment
    stack.distribution = distribution
    stack.spacing = spacing
    if margins != .zero {
      stack.isLayoutMarginsRelativeArrangement = true
      stack.layoutMargins = margins
    }
    return stack
  }
}

public typealias SpacerRelation = NSLayoutConstraint.Relation
public enum SpacerValue {
  case point(_ value: CGFloat, _ relation: SpacerRelation = .equal)
  case fraction(_ value: CGFloat, _ relation: SpacerRelation = .equal)
}

private final class Spacer: UIView {
  private let length: SpacerValue
  //  private let isFixed: Bool
  private var axis: NSLayoutConstraint.Axis?
  private var observer: AnyObject?
  private var _constraints: [NSLayoutConstraint] = []
  
  
  init(value: SpacerValue) {
    self.length = value
    super.init(frame: .zero)
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    guard let stackView = newSuperview as? UIStackView else {
      axis = nil
      observer = nil
      setNeedsUpdateConstraints()
      return
    }
    
    axis = stackView.axis
    observer = stackView.observe(\.axis, options: [.initial, .new]) { [weak self] _, axis in
      self?.axis = axis.newValue
      self?.setNeedsUpdateConstraints()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate override func updateConstraints() {
    guard let stackView = superview as? UIStackView else { return }
    
    NSLayoutConstraint.deactivate(_constraints)
    
    let attributes: [NSLayoutConstraint.Attribute]
    switch axis {
      case .horizontal: attributes = [.width]
      case .vertical: attributes = [.height]
      default: attributes = [.height, .width] // Not really an expected use-case
    }
    _constraints = attributes.map {
      let constraint: NSLayoutConstraint
      switch self.length {
        case let .point(value, relation):
          constraint = NSLayoutConstraint(item: self, attribute: $0, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        case let .fraction(value, relation):
          constraint = NSLayoutConstraint(item: self, attribute: $0, relatedBy: relation, toItem: stackView, attribute: $0, multiplier: value, constant: 0)
      }
      constraint.priority = UILayoutPriority(999)
      return constraint
    }
    
    NSLayoutConstraint.activate(_constraints)
    super.updateConstraints()
  }
}
extension UIStackView {
  convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment, spacing: CGFloat) {
    self.init()
    self.axis = axis
    self.alignment = alignment
    self.spacing = spacing
  }
}
