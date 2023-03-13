//
//  TabBarVcCartDelegate.swift
//  
//
//  Created by Cristina Dobson
//


// CartViewControllerDelegate

extension TabBarController: CartViewControllerDelegate {
  
  
  // MARK: - Remove item from Shopping Cart
  
  func updateShoppingCartProducts(_ products: [ShoppingCartProduct]) {
    shoppingCartProducts = products
    
    let count = coreDataService.getShoppingCartCount()
    setupCartTabBarItemBadge(with: count)
  }
  
  
  // MARK: - Update Shopping Cart items array
  
  /*
   Update the shoppingCartProducts array in CartViewController,
   when the user adds a new product to Shopping Cart from
   ProductCatalogViewController and ProductPageViewController
   */
  func updateProductsInShoppingCart(on viewController: CartViewController) {
    viewController.shoppingCartProducts = shoppingCartProducts
  }
  
  func updateTabBarBadge() {
    let count = coreDataService.getShoppingCartCount()
    setupCartTabBarItemBadge(with: count)
  }
}






