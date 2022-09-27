//
//  AnimationRoute.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/8.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import XCoordinator

extension RedirectionRouter {
  var unownedRouter: UnownedRouter<RouteType> {
    UnownedRouter(self) { $0.strongRouter }
  }
}


/*
class ParentCoordinator: NavigationCoordinator<ParentRoute> {
  /* ... */

  override func prepareTransition(for route: ParentRoute) -> NavigationTransition {
    switch route {
    /* ... */
    case .child:
      let childCoordinator = ChildCoordinator(parent: unownedRouter)
      return .push(childCoordinator)
    }
  }
}

class ChildCoordinator: RedirectionRouter<ParentRoute, ChildRoute> {
  init(parent: UnownedRouter<ParentRoute>) {
    let viewController = UIViewController()
    // this viewController is used when performing transitions with the Subcoordinator directly.
    super.init(viewController: viewController, parent: parent, map: nil)
  }
  
  /* ... */
  
  override func mapToParentRoute(for route: ChildRoute) -> ParentRoute {
    // you can map your ChildRoute enum to ParentRoute cases here that will get triggered on the parent router.
  }
}
 */

enum AnimationRoute: Route {
  case test
  case test0
}

final class AnimationContentCoordinator: RedirectionRouter<MainRoute, AnimationRoute> {
  
  init(parent: UnownedRouter<MainRoute>) {
    let vc = AnimationContentViewController()
    super.init(viewController: vc, parent: parent) { childRote in
      
      switch childRote {
      case .test:
        break
      case .test0:
        break
      }
      return MainRoute.animationContent
    }
    vc.router = unownedRouter
  }
  
//  override func mapToParentRoute(_ route: AnimationRoute) -> MainRoute {
//
//  }
//  override init(rootViewController: NavigationCoordinator<AnimationRoute>.RootViewController = .init(), initialRoute: AnimationRoute? = nil) {
//    super.init(rootViewController: rootViewController, initialRoute: initialRoute)
//  }
  
//  override func prepareTransition(for route: AnimationRoute) -> NavigationTransition {
//    switch route {
//    case .test:
//      return .push(AnimationViewController())
//    case .test0:
//      return .push(CoreGraphicTableViewController())
//    }
//  }
//  override func prepareTransition(for route: AnimationRoute) -> ViewTransition {
//    switch route {
//    case .test:
//      return .pus
//    }
//  }
}
