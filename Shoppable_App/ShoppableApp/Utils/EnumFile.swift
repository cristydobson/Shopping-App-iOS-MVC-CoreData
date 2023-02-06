/*
 EnumFile.swift
 ShoppableApp
 
 Created on 1/25/23.
 
 These enums contain keys to use with UserDefaults,
 Dictionaries.
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
  case type
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
