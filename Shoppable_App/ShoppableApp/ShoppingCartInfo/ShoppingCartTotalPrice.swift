/*
 ShoppingCartTotalPrice.swift
 ShoppableApp
 
 Created on 1/23/23.
 
 Get and update the total price of the Shopping Cart
 stored in UserDefaults
 */

import Foundation


// MARK: - Update the Shopping Cart's total price ******
// Update the Shopping Cart total in UserDefaults
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


// MARK: - Get Shopping Cart total price ******
// Get the Shopping Cart total from UserDefaults
func getShoppingCartTotal() -> Double {
  let shoppingCartTotalKey = "shoppingCartTotal"
  
  if let shoppingCartTotal = UserDefaults.standard.object(forKey: shoppingCartTotalKey) as? Double {
    return shoppingCartTotal
  }
  return 0.0
}



  
