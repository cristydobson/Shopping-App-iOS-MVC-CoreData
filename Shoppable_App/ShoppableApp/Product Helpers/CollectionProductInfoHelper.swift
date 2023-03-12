//
//  CollectionProductInfoHelper.swift
//  ShoppableApp
//
//  Created on 2/8/23.
//


import Foundation


// MARK: - Product Collection Types enum

// Product Collection Types
enum CollectionType: String, CaseIterable {
  case couch
  case chair
  
  // Returns the title to use in ProductCatalogViewController
  var productTypeTitle: String {
    switch self {
      case .couch:
        return "Couches"
      case .chair:
        return "Chairs"
    }
  }
}


struct CollectionProductInfoHelper {
  
  // MARK: - Get Product Collection
  
  // Get the product array of the correct collection type
  static  func getProductCollection(from array: [ProductCollection], of type: String) -> ProductCollection? {
    
    for collection in array {
      if collection.type == type {
        return collection
      }
    }
    return nil
  }
  
  
  // MARK: - Get localized Product Collection type
  
  // Get the product collection type localized name
  static  func getProductCollectionTypeLocalizedName(from index: Int) -> String {
    
    let collectionTypeCases = CollectionType.allCases
    
    if index <= collectionTypeCases.count-1 {
      let collectionName = collectionTypeCases[index].productTypeTitle
      return NSLocalizedString(
        collectionName,
        comment: "Collection type")
    }
    
    return ""
  }
  
  
  // MARK: - Find product from the shopping cart in a product collection
  
  // Find the product from the Shopping Cart
  static  func getProductFromShoppingCartIn(in collection: ProductCollection, for productID: String) -> Product? {
    
    // Get the products array from the collection type
    let productsArray = collection.products
    
    // Loop throught the array to find the product in the ShoppingCart
    for product in productsArray {
      
      if product.id == productID {
        // If you find it, add it to the itemsInShoppingCart array
        return product
      }
    }
    
    return nil
  }

  
}















