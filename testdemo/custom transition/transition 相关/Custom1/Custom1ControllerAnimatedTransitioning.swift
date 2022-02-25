//
//  Custom1ControllerAnimatedTransitioning.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit

final class Custom1ControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    2
  }
  
  /*
   UIKit calls this method when presenting or dismissing a view controller.
   Use this method to configure the animations associated with your custom transition.
   You can use view-based animations or Core Animation to configure your animations.
   All animations must take place in the view specified by the containerView property of transitionContext.
   Add the view being presented (or revealed if the transition involves dismissing a view controller)
   to the container view’s hierarchy and set up any animations you want to make that view move into position.
   If you want to draw to the screen directly without a view, use this method to configure a CADisplayLink object instead.
   You can retrieve the view controllers involved in the transition from the viewController(forKey:) method of transitionContext.
   For more information about the information provided by the context object, see UIViewControllerContextTransitioning.
   */
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to),
          let fromViewController = transitionContext.viewController(forKey: .from),
          let toView = toViewController.view,
          let fromView = fromViewController.view else { return }
    
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    
    if toViewController.isBeingPresented {
      containerView.addSubview(toView)
      let toViewWidth = containerView.frame.width * 2 / 3
      let toViewHeight = containerView.frame.height * 2 / 3
      toView.center = containerView.center
      toView.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewHeight)
      UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
        toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
      }, completion: {_ in
        /*
         You must call this method after your animations have completed to notify the system that the transition animation is done.
         The parameter you pass must indicate whether the animations completed successfully. For interactive animations,
         you must call this method in addition to the finishInteractiveTransition() or cancelInteractiveTransition() method.
         The best place to call this method is in the completion block of your animations.
         The default implementation of this method calls the animator object’s
         animationEnded(_:) method to give it a chance to perform any last minute cleanup.
         */
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
    
    //Dismissal 转场中不要将 toView 添加到 containerView
    if fromViewController.isBeingDismissed {
      let fromViewHeight = fromView.frame.height
      UIView.animate(withDuration: duration, animations: {
        fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight)
      }, completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
  }
}
