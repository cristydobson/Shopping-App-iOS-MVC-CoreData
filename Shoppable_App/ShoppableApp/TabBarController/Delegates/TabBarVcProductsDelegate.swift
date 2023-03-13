//
//  TabBarVcProductsDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
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
    setupCartTabBarItemBadge(with: Int(shoppingCart.productCount))
    
    // Update the total price in Shopping Cart in UserDefaults
    let price = product.price.value
    updateShoppingCartTotalInCoreData(with: price)
    
  }
  
}
