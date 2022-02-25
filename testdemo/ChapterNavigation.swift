//
//  ChapterNavigation.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/20.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import Foundation
import UIKit

enum Chapter: CaseIterable, ViewControllerMaker, Navigation {
  case randomTest
  case operators
  case uidemos
  case router
  case xib
  case pageGround
  case animation
  case presentation
  case parallax
  case stickyMenu
  case matix
  case customTransiton
  case coreGraphic
  case partyMode
  case genericTableView
  case pagingListView
  case floatButton
  case glossyButton
  
  var viewController: UIViewController {
    switch self {
      case .randomTest:       return RandomTestViewController()
      case .operators:        return RxOperatorController()
      case .uidemos:          return ViewController()
      case .router:           return ViewController()
      case .xib:              return XibDemoViewController.loadFromNib()
      case .pageGround:       return TopContainerViewController()
      case .animation:        return AnimationViewController()
      case .presentation:     return PresentFromViewController()
      case .parallax:         return ParallaxViewController()
      case .stickyMenu:       return StickyMenuTabViewController()
      case .matix:            return MatrixViewController()
      case .customTransiton:  return CustomTransition__ViewController()
      case .coreGraphic:      return CoreGraphicTableViewController()
      case .partyMode:        return PartyModeViewController()
      case .genericTableView: return GenericTableViewController<RecentItem>(items: recentItems, cellConfigurator: {
        $0.cellConfigurator
      })
      case .pagingListView:return PagingListViewController(viewModel: PagingListViewModel())
    case .floatButton: return DrawBallViewController()
    case .glossyButton: return GlossyButtonViewController()
    }
  }
}
