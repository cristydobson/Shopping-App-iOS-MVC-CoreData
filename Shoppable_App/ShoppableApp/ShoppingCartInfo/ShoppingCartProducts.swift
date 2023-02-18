//
//  ShoppingCartProducts.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//

import Foundation


struct ShoppingCartProducts {
  
  // MARK: - Get Products in Shopping Cart
  
  /*
   Get the Shopping Cart products from
   the product collections
   */
  static func getProductsInShoppingCart(_ array: [ProductDictionary], from collections: [ProductCollection]) -> [Product] {
    
    var products: [Product] = []
    
    for item in array {
      /*
       1.- Make sure there's a product ID
       2.- Get the collection type
       3.- Get the product array of the correct collection type
       4.- Find the product in the Shopping Cart
       */
      
      let productID = ShoppingCartProductInfo.getShoppingCartItemID(from: item)
      let collectionType = ShoppingCartProductInfo.getShoppingCartItemType(from: item)
      if
        let collection = ProductCollectionInfo.getProductCollection(from: collections, of: collectionType),
        let product = ProductCollectionInfo.getProductFromShoppingCartIn(in: collection, for: productID)
      {
        products.append(product)
      }
      
    }
    
    return products
  }

  // MARK: - Get Product Count in Shopping Cart
  
  // Get the product count in the Shopping Cart
  static func getItemCountInShoppingCart(from array: [ProductDictionary]) -> Int {
    var itemCount = 0
    for item in array {
      if let itemsInShoppingCartCount = item[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int {
        itemCount += itemsInShoppingCartCount
      }
    }
    return itemCount
  }
  
  
  // MARK: - Save Shopping Cart Product IDs
  
  // Save Shopping Cart products in UserDefaults
  static func saveShoppingCartProductsInUserDefaults(_ array: [ProductDictionary]) {
    UserDefaults.standard.set(array,
                              forKey: "itemsInShoppingCartArray"
    )
  }
  
}





