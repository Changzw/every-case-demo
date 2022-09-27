//
//  MainRoute.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/3/8.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import Foundation
import XCoordinator

// 目录
enum MainRoute: Route, CaseIterable {
  case content
  case segmentView
  case coreGraphic
  case randomTest
  case operators
  case uidemos
  case router
  case xib
  case pageGround
  case animationContent
  case presentation
  case parallax
  case stickyMenu
  case matix
  case customTransiton
  case partyMode
  case genericTableView
  case pagingListView
  case floatButton
  case glossyButton
}

final class MainContentCoordinator: NavigationCoordinator<MainRoute> {
  init() {
    super.init(initialRoute: .content)
  }

//  let ani = AnimationContentCoordinator()
  override func prepareTransition(for route: MainRoute) -> NavigationTransition {
    switch route {
    case .content:
      return .push(MainContentController(router: unownedRouter))
    case .randomTest:
      return .push(RandomTestViewController())
    case .operators:
      return .push(RxOperatorController())
    case .uidemos:
      return .push(ViewController())
    case .router:
      return .push(ViewController())
    case .xib:
      return .push(XibDemoViewController.loadFromNib())
    case .pageGround:
      return .push(TopContainerViewController())
    case .animationContent:
//      return .push(AnimationContentCoordinator(rootViewController: rootViewController, initialRoute: .test0))
      return .push(AnimationContentCoordinator(parent: unownedRouter))
//      return .push(AnimationContentCoordinator(viewController: <#T##UIViewController#>, parent: <#T##UnownedRouter<MainRoute>#>, map: <#T##((AnimationRoute) -> MainRoute)?##((AnimationRoute) -> MainRoute)?##(AnimationRoute) -> MainRoute#>))
    case .presentation:
      return .push(PresentFromViewController())
    case .parallax:
      return .push(ParallaxViewController())
    case .stickyMenu:
      return .push(StickyMenuTabViewController())
    case .matix:
      return .push(MatrixViewController())
    case .customTransiton:
      return .push(CustomTransition__ViewController())
    case .partyMode:
      return .push(PartyModeViewController())
    case .genericTableView:
      return .push(GenericTableViewController<RecentItem>(items: recentItems, cellConfigurator: {
        $0.cellConfigurator
      }))
    case .pagingListView:
      return .push(PagingListViewController(viewModel: PagingListViewModel()))
    case .floatButton:
      return .push(DrawBallViewController())
    case .glossyButton:
      return .push(GlossyButtonViewController())
    case .coreGraphic:
      return .show(CoreGraphicCoordinator().strongRouter)
    case .segmentView:
      return .push(SegmentViewController())
    }
  }
}
