//
//  TabBarControllerDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


import UIKit


// UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
  
  
  // MARK: - User tapped on TabBarItem
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
    let selectedTabIndex = tabBarController.selectedIndex
    
    if selectedTabIndex != currentTabIndex {
      currentTabIndex = selectedTabIndex
      let navController = viewController as! UINavigationController
      let viewController = navController.topViewController
      
      // Update data in a tapped tabBar View Controller
      switch selectedTabIndex {
        case 1:
          if let currentController = viewController as? CartViewController {
            currentController.shoppingCartProducts = shoppingCartProducts
          }
        default:
          print("Collections Tab")
      }
    }
  }

}













