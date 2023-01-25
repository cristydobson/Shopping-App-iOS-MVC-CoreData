/*
 EnumFile.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/25/23.
 
 These enums contain keys to use with UserDefaults,
 Dictionaries and JSON files.
 Organizing them like this helps to avoid typos.
 */

import Foundation


/*
 Keys used to store in UserDefaults the IDs of the products
 in the Shopping Cart
 */
enum UserDefaultsKeys: String {
  case id
  case inShoppingCartCount
  case productCollectionType
}


//Keys used to get product data from the JSON file
enum ProductDataKeys: String {
  case products
  case id
  case name
  case price
  case value
  case currency
  case info
  case color
  case type
  case imageUrl
  case numberOfSeats
  case material
}


//Product Collection Types
enum CollectionType: String, CaseIterable {
  case couch
  case chair
  
  //Returns the title to use in ProductCatalogViewController
  var productTypeTitle: String {
    switch self {
      case .couch:
        return "Couches"
      case .chair:
        return "Chairs"
    }
  }
}

//Keys used in the Checkmark animation
enum AnimationKey: String {
  case strokeEnd
  case animateCheckmark
}
