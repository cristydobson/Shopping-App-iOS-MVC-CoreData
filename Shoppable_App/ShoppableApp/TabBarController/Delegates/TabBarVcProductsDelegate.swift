//
//  TabBarVcProductsDelegate.swift
//
//
//  Created by Cristina Dobson
//


// ProductOverviewViewControllerDelegate

extension TabBarController: ProductOverviewViewControllerDelegate {
  
  
  // MARK: - Update CartViewController
  
  /*
   The user has added new items to the Shopping Cart from
   ProductCatalogViewController or ProductPageViewController
   */
  func updateCartControllerFromProductCatalogController(with product: Product) {
    
    saveToShoppingCartInCoreData(product: product)

    // Update the Cart TabBar item's badge
    let count = coreDataService.getShoppingCartCount()
    setupCartTabBarItemBadge(with: count)
    
  }
  
}
