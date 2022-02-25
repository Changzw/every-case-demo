//
//  Builder.swift
//  Stacks
//
//  Created by 常仲伟 on 2021/10/21.
//

import UIKit 

protocol StackNode {
  var subNodes: [UIView] { get }
}

extension UIView: StackNode {
  var subNodes: [UIView] { [self] }
}

struct ComponentNode: StackNode {
  let views: [UIView]
  var subNodes: [UIView] { views }
}

struct EmptyNode: StackNode {
  var subNodes: [UIView] { [] }
}

@resultBuilder
struct StackBuilder {
  static func buildBlock(_ component: StackNode) -> StackNode {
    return component
  }
  
  static func buildBlock(_ components: StackNode...) -> StackNode {
    ComponentNode(views: components.flatMap{ $0.subNodes })
  }
  
  static func buildBlock(_ components: [StackNode]) -> StackNode {
    ComponentNode(views: components.flatMap{ $0.subNodes })
  }
  
  static func buildArray(_ components: [StackNode]) -> StackNode {
    ComponentNode(views: components.flatMap{ $0.subNodes })
  }
  
  static func buildEither(first component: StackNode) -> StackNode {
    component
  }
  
  static func buildEither(second component: StackNode) -> StackNode {
    component
  }
  
  static func buildOptional(_ component: StackNode?) -> StackNode {
    component ?? EmptyNode()
  }
}

final class VStack: UIStackView {
  init(@StackBuilder nodes: () -> StackNode) {
    super.init(frame: .zero)
    axis = .vertical
    translatesAutoresizingMaskIntoConstraints = false
    nodes().subNodes.forEach { addArrangedSubview($0) }
  }
  required init(coder: NSCoder) { super.init(coder: coder) }
}

protocol StackModifier {
  associatedtype Stack: UIStackView
  func alignment(_ alignment: Stack.Alignment) -> Stack
  func distribution(_ distribution: Stack.Distribution) -> Stack
  func spacing(_ spacing: CGFloat) -> Stack
  func insets(_ insets: UIEdgeInsets) -> Stack
  func insets(dx: CGFloat, dy: CGFloat) -> Stack
  func insetAll(_ d: CGFloat) -> Stack
}

extension VStack: StackModifier {
  func insetAll(_ d: CGFloat) -> VStack {
    insets(dx: d, dy: d)
  }
  
  func insets(dx: CGFloat, dy: CGFloat) -> VStack {
    insets(UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
  }

  func insets(_ insets: UIEdgeInsets) -> VStack {
    isLayoutMarginsRelativeArrangement = insets != .zero
    self.layoutMargins = insets
    return self
  }
  
  func alignment(_ alignment: UIStackView.Alignment) -> VStack {
    self.alignment = alignment
    return self
  }
  
  func distribution(_ distribution: UIStackView.Distribution) -> VStack {
    self.distribution = distribution
    return self
  }
  
  func spacing(_ spacing: CGFloat) -> VStack {
    self.spacing = spacing
    return self
  }
}

final class HStack: UIStackView {
  init(@StackBuilder nodes: () -> StackNode) {
    super.init(frame: .zero)
    axis = .horizontal
    translatesAutoresizingMaskIntoConstraints = false
    nodes().subNodes.forEach { addArrangedSubview($0) }
  }
  required init(coder: NSCoder) { super.init(coder: coder) }
}

extension HStack: StackModifier {
  func insetAll(_ d: CGFloat) -> HStack {
    insets(dx: d, dy: d)
  }

  func insets(dx: CGFloat, dy: CGFloat) -> Stack {
    insets(UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
  }

  func insets(_ insets: UIEdgeInsets) -> HStack {
    isLayoutMarginsRelativeArrangement = insets != .zero
    self.layoutMargins = insets
    return self
  }
  
  func alignment(_ alignment: UIStackView.Alignment) -> HStack {
    self.alignment = alignment
    return self
  }
  
  func distribution(_ distribution: UIStackView.Distribution) -> HStack {
    self.distribution = distribution
    return self
  }
  
  func spacing(_ spacing: CGFloat) -> HStack {
    self.spacing = spacing
    return self
  }
}

protocol ViewModifier {
  associatedtype View: UIView
  func box(offset: CGFloat) -> View
  func width(_ width: SpacerValue) -> View
  func height(_ height: SpacerValue) -> View
  func cornerRadius(_ cornerRadius: CGFloat) -> View
  func backgroundColor(_ backgroundColor: UIColor) -> View
}

extension UIView: ViewModifier {
  @discardableResult
  func box(offset: CGFloat) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    guard let superview = superview else { return self }
    
    let firstItemAnchors = Set([topAnchor, leadingAnchor, trailingAnchor, bottomAnchor])
    constraints
      .filter { firstItemAnchors.contains($0.firstAnchor) }
      .forEach { $0.isActive = false }
    
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor, constant: offset),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offset),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -offset),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: offset)
    ])
    
    return self
  }
  
  @discardableResult
  public func width(_ width: SpacerValue) -> UIView {
    if let w = constraints.first(where: { $0.firstAnchor == widthAnchor }) {
      w.isActive = false
    }
    translatesAutoresizingMaskIntoConstraints = false
    let constraint: NSLayoutConstraint
    switch width {
      case let .fraction(value, relation):
        constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: superview, attribute: .width, multiplier: value, constant: 0)
      case let .point(value, relation):
        constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
    }
    constraint.priority = UILayoutPriority(999)
    constraint.isActive = true
    return self
  }
  
  @discardableResult
  public func height(_ height: SpacerValue) -> UIView {
    if let h = constraints.first(where: { $0.firstAnchor == heightAnchor }) {
      h.isActive = false
    }
    let constraint: NSLayoutConstraint
    switch height {
      case let .fraction(value, relation):
        constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: superview, attribute: .height, multiplier: value, constant: 0)
      case let .point(value, relation):
        constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
    }
    constraint.priority = UILayoutPriority(999)
    constraint.isActive = true
    return self
  }
  
  @discardableResult
  public func cornerRadius(_ cornerRadius: CGFloat) -> UIView {
    layer.cornerRadius = cornerRadius
    return self
  }
  
  @discardableResult
  public func backgroundColor(_ color: UIColor) -> UIView {
    backgroundColor = color
    return self
  }
  
  @discardableResult
  public func contentCompressionResistancePriority(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    setContentCompressionResistancePriority(priority, for: axis)
    return self
  }
  
  @discardableResult
  public func contentHuggingPriority(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) -> UIView {
    translatesAutoresizingMaskIntoConstraints = false
    setContentHuggingPriority(priority, for: axis)
    return self
  }
}
