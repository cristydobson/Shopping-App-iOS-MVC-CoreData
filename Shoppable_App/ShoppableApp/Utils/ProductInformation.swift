/*
 ProductInformation.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/23/23.
 
 Functions to get the product information from
 a dictionary [String:AnyObject]
 */

import Foundation

class ProductInformation {
  
  //Get the name of the product
  func getProductName(from dictionary: ProductDictionary) -> String {
    if let name = dictionary[ProductDataKeys.name.rawValue] as? String {
      return name
    }
    return ""
  }
  
  //Get the Info Dictionary of the product
  func getProductInfo(from dictionary: ProductDictionary) -> ProductDictionary? {
    if let info = dictionary[ProductDataKeys.info.rawValue] as? ProductDictionary {
      return info
    }
    return nil
  }
  
  //Get the Info Dictionary keys from the product
  func getProductInfoKeys(from dictionary: ProductDictionary) -> [String] {
    if let infoArray = Array(dictionary.keys) as? [String] {
      return infoArray
    }
    return []
  }
  
  //Get the price of the product as a Double
  func getProductPrice(from dictionary: ProductDictionary) -> Double {
    if
      let price = dictionary[ProductDataKeys.price.rawValue] as? ProductDictionary,
      let priceValue = price[ProductDataKeys.value.rawValue] as? Double
    {
      return priceValue
    }
    return 0.0
  }
  
  //Get the price currency for the product
  func getProductPriceCurrency(from dictionary: ProductDictionary) -> String {
    if
      let price = dictionary[ProductDataKeys.price.rawValue] as? ProductDictionary,
      let priceCurrency = price[ProductDataKeys.currency.rawValue] as? String
    {
      return priceCurrency
    }
    return ""
  }
  
  //Get the product count in the Shopping Cart 
  func getProductCountInShoppingCart(for currentProduct: ProductDictionary, from itemsInShoppingCartIDsArray: [ProductDictionary]) -> Int {
    
    if let currentProductID = currentProduct[ProductDataKeys.id.rawValue] as? String {
      for productDict in itemsInShoppingCartIDsArray {
        if
          let productId = productDict[UserDefaultsKeys.id.rawValue] as? String,
          productId == currentProductID,
          let itemCount = productDict[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int
        {
          return itemCount
        }
      }
    }
    return 0
  }
  
  //Create the description string of a product
  func createDescriptionString(with dictKeys: [String], from info: ProductDictionary) -> String {
    
    var resultString = ""
    for key in dictKeys {
      if
        key == ProductDataKeys.color.rawValue,
        let lastValue = info[key] as? String
      {
        resultString += NSLocalizedString(lastValue, comment: "Color of the product")
      }
      else if let firstStringValue = info[key] as? String {
        resultString = NSLocalizedString(firstStringValue, comment: "Material of the chair") + ", " + resultString
        resultString = resultString.capitalizingFirstLetter()
      }
      else if let firstIntValue = info[key] as? Int {
        resultString =
          "\(firstIntValue) " +
          NSLocalizedString("seats", comment: "Seat count of a couch") +
          ", " +
          resultString
      }
    }
    
    return resultString
  }
}
