//
//  Custom1PresentationController.swift
//  testdemo
//
//  Created by 常仲伟 on 2021/6/22.
//  Copyright © 2021 常仲伟. All rights reserved.
//

import UIKit
import RxSwift

/*
 summary
 An object that manages the transition animations and the presentation of view controllers onscreen.
 
 From the time a view controller is presented until the time it is dismissed,
 UIKit uses a presentation controller to manage various aspects of the presentation process for that view controller.
 
 1. The presentation controller can add its own animations on top of those provided by animator objects,
 2. it can respond to size changes, and it can manage other aspects of how the view controller is presented onscreen.
 3. When you present a view controller using the present(_:animated:completion:) method, UIKit always manages the presentation process.
 Part of that process involves creating the presentation controller that is appropriate for the given presentation style.
 For the built-in styles (such as the UIModalPresentationStyle.pageSheet style),
 UIKit defines and creates the needed presentation controller object.
 The only time your app can provide a custom presentation controller is when
 you set the modalPresentationStyle property of your view controller UIModalPresentationStyle.custom.
 4. You might provide a custom presentation controller when you want to add a shadow view or decoration views
 underneath the view controller being presented or when you want to modify the presentation behavior in other ways.
 5. You vend your custom presentation controller object through your view controller’s transitioning delegate.
 UIKit maintains a reference to your presentation controller object while the presented view controller is onscreen.
 For information about the transitioning delegate and the objects it provides,
 see UIViewControllerTransitioningDelegate.
 */
 
final class Custom1PresentationController: UIPresentationController {
//  1. dimmingView
  private lazy var dimmingView = UIView()
  
  override func presentationTransitionWillBegin() {
//    dimmingView.rx.sentMessage(#selector(UIView.touchesEnded(_:with:)))
//      .bind{[unowned self] _ in
//        self.presentedViewController.dismiss(animated: true, completion: nil)
//      }
//      .disposed(by: rx.disposeBag)
    containerView?.isUserInteractionEnabled = false
    containerView?.addSubview(dimmingView)
    dimmingView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
  }
  
  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    }, completion: nil)
  }
}
