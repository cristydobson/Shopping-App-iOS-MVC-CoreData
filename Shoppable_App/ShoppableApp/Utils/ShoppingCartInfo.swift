/*
 ShoppingCartInfo.swift
 ShoppableApp
 
 Created on 1/23/23.
 
 Get and update the total price of the Shopping Cart
 stored in UserDefaults
 */

import Foundation


//MARK: - Item ID ******
//Get the Shopping Cart item ID
func getShoppingCartItemID(from product: ProductDictionary) -> String {
  if let id = product[UserDefaultsKeys.id.rawValue] as? String {
    return id
  }
  return ""
}


//MARK: - Item Type ******
func getShoppingCartItemType(from product: ProductDictionary) -> String {
  if let type = product[UserDefaultsKeys.type.rawValue] as? String {
    return type
  }
  return ""
}

//MARK: - Item Count in Shopping Cart ******
//Get the product count in the Shopping Cart
func getProductCountInShoppingCart(from currentProduct: ProductDictionary) -> Int {
  if let productCount = currentProduct[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int {
    return productCount
  }
  
  return 0
}



//MARK: - Update the Shopping Cart's total price ******
//Update the Shopping Cart total in UserDefaults
func updateTheShoppingCartTotal(with amount: Double) {
  let shoppingCartTotalKey = "shoppingCartTotal"
  
  if let shoppingCartTotal = UserDefaults.standard.object(forKey: shoppingCartTotalKey) as? Double {
    
    let newTotal = shoppingCartTotal + amount
    let positiveTotal = newTotal > 0 ? newTotal : 0.0
    UserDefaults.standard.set(
      positiveTotal,
      forKey: shoppingCartTotalKey
    )
  }
  else if amount > 0 {
    UserDefaults.standard.set(
      amount,
      forKey: shoppingCartTotalKey
    )
  }
}


//MARK: - Get Shopping Cart total price ******
//Get the Shopping Cart total from UserDefaults
func getShoppingCartTotal() -> Double {
  let shoppingCartTotalKey = "shoppingCartTotal"
  
  if let shoppingCartTotal = UserDefaults.standard.object(forKey: shoppingCartTotalKey) as? Double {
    return shoppingCartTotal
  }
  return 0.0
}




  
