//
//  ShoppingCartProductInfo.swift
//  ShoppableApp
//
//  Created on 2/8/23.
//

import Foundation


// MARK: - Shopping Cart Keys enum
/*
 Keys used to store in UserDefaults the IDs of the products
 in the Shopping Cart
 */
enum UserDefaultsKeys: String {
  case id
  case inShoppingCartCount
  case type
}


// MARK: - Item ID ******
// Get the Shopping Cart item ID
func getShoppingCartItemID(from product: ProductDictionary) -> String {
  if let id = product[UserDefaultsKeys.id.rawValue] as? String {
    return id
  }
  return ""
}


// MARK: - Item Type ******
// Get the Shopping Cart item type
func getShoppingCartItemType(from product: ProductDictionary) -> String {
  if let type = product[UserDefaultsKeys.type.rawValue] as? String {
    return type
  }
  return ""
}


// MARK: - Item Count in Shopping Cart ******
// Get the product count in the Shopping Cart
func getProductCountInShoppingCart(from currentProduct: ProductDictionary) -> Int {
  if let productCount = currentProduct[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int {
    return productCount
  }
  return 0
}












