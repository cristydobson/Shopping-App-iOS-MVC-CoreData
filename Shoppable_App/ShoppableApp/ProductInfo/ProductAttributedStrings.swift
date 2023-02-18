//
//  ProductAttributedStrings.swift
//  ShoppableApp
//
//  Created on 2/8/23.
//

import Foundation


struct ProductAttributedStrings {
  
  // MARK: - Product Name ******
  static func getAttributedName(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
    
    let name = product.name.uppercased()
    return name.toStyleString(with: fontSize, and: .bold)
  }
  
  
  // MARK: - Product Price ******
  // Get attributed Price String
  static func getAttributedPrice(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
    
    let formattedPrice = product.price.value.toCurrencyFormat()
    return formattedPrice.toCurrencyAttributedString(with: fontSize)
  }
  
  
  // MARK: - Product Description ******
  // Get attributed Description String
  static func getAttributedDescription(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString? {
    
    let productDescription = createDescriptionString(for: product)
    if productDescription != "" {
      let attributedDescription = productDescription.toStyleString(with: fontSize, and: .regular)
      return attributedDescription
    }
    return nil
  }

  
}











