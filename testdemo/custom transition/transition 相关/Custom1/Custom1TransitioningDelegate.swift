//
//  Custom1TransitioningDelegate.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class Custom1TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
//MARK: 1 转场动画
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    Custom1ControllerAnimatedTransitioning()
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    Custom1ControllerAnimatedTransitioning()
  }
  
//MARK: 2
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    nil
  }
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    nil
  }
  
//MARK: 3
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    Custom1PresentationController(presentedViewController: presented, presenting: presenting)
  }
}
