//
//  CartViewControllerDelegate.swift
//
//
//  Created by Cristina Dobson
//


import Foundation


// CartViewController Delegate

protocol CartViewControllerDelegate: AnyObject {
  
  func updateShoppingCartProducts(_ products: [ShoppingCartProduct])
  
  // Called in the "Add To Cart" observer
  func updateProductsInShoppingCart(
    on viewController: CartViewController)
  
  func updateTabBarBadge()
  
}
