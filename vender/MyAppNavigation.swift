//
//  MyAppNavigation.swift
//  testdemo
//
//  Created by 常仲伟 on 2020/12/16.
//  Copyright © 2020 常仲伟. All rights reserved.
//

import Foundation
import UIKit

struct MyAppNavigation: AppNavigation {
  
  func viewcontrollerForNavigation(navigation: Navigation) -> UIViewController {
    if let navigation = navigation as? Chapter {
      switch navigation {
      case .randomTest:     return RandomTestViewController()
      case .operators:      return RxOperatorController()
      case .uidemos:        return ViewController()
      case .router:         return ViewController()
      case .xib:            return XibDemoViewController(nibName: "XibDemoViewController", bundle: Bundle.main)
      case .pageGround:     return TopContainerViewController()
      case .animation:      return AnimationViewController()
      case .presentation:   return PresentFromViewController()
      case .parallax:       return ParallaxViewController()
      case .stickyMenu:     return StickyMenuTabViewController()
      case .matix:          return MatrixViewController()
      case .customTransiton: return CustomTransition__ViewController()
      case .coreGraphic:    return CoreGraphicTableViewController()
      case .partyMode:      return PartyModeViewController()
      case .genericTableView:return GenericTableViewController<RecentItem>(items: recentItems, cellConfigurator: {
        $0.cellConfigurator
      })
      case .pagingListView:return PagingListViewController(viewModel: PagingListViewModel())
      case .floatButton: return DrawBallViewController()
      case .glossyButton: return GlossyButtonViewController()
      }
    }
    return UIViewController()
  }
  
  func navigate(_ navigation: Navigation, from: UIViewController, to: UIViewController) {
    if let navigation = navigation as? Chapter {
      switch navigation {
        case .pageGround:
          from.present(to, animated: true, completion: nil)
        default:
          from.navigationController?.pushViewController(to, animated: true)
      }
    }
  }
}

extension UIViewController {
  func navigate(_ navigation: Chapter) {
    navigate(navigation as Navigation)// hehe
  }
}

