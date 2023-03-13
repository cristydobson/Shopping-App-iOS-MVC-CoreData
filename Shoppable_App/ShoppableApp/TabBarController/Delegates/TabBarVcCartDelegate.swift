//
//  TabBarVcCartDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// CartViewControllerDelegate

extension TabBarController: CartViewControllerDelegate {
  
  
  // MARK: - Remove item from Shopping Cart
  
  func updateShoppingCartProducts(_ products: [ShoppingCartProduct]) {
    shoppingCartProducts = products
    setupCartTabBarItemBadge(with: Int(shoppingCart.productCount))
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
    setupCartTabBarItemBadge(with: Int(shoppingCart.productCount))
  }
}






