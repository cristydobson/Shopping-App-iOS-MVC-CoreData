//
//  TabBarVcCartDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// CartViewControllerDelegate

extension TabBarController: CartViewControllerDelegate {
  
  
  // MARK: - Remove item from Shopping Cart
  
  // The user removed a product from the shopping cart with count > 0
  func didTapRemoveItemFromCartController(_ count: Int, from index: Int) {
    itemsInShoppingCartIDs.remove(at: index)
    itemsInShoppingCartCount -= count
    setupCartTabBarItemBadge(with: itemsInShoppingCartCount)
  }
  
  
  // MARK: - Update item count in Shopping Cart
  
  // The user changed the quantity of a product in the Shopping Cart by >= 1
  func didUpdateItemQuantityFromCartController(_ count: Int, with updatedArray: [ProductDictionary]) {
    itemsInShoppingCartCount += count
    itemsInShoppingCartIDs = updatedArray
    setupCartTabBarItemBadge(with: itemsInShoppingCartCount)
  }
  
  
  // MARK: - Update Shopping Cart items array
  
  /*
   Update the itemsInShoppingCartIDs array in CartViewController,
   when the user adds a new product to Shopping Cart from
   ProductCatalogViewController and ProductPageViewController
   */
  func updateItemsInShoppingCartIDs(on viewController: CartViewController) {
    viewController.itemsInShoppingCartIDs = itemsInShoppingCartIDs
  }
}






