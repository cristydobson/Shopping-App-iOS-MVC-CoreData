//
//  ProductAttributedStrings.swift
//  ShoppableApp
//
//  Created on 2/8/23.
//

import Foundation


// MARK: - Product Name ******
func getAttributedName(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
  
  let name = product.name.uppercased()
  return name.toStyleString(with: fontSize, and: .bold)
}


// MARK: - Product Price ******
// Get attributed Price String
func getAttributedPrice(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
  
  let formattedPrice = product.price.value.toCurrencyFormat()
  return formattedPrice.toCurrencyAttributedString(with: fontSize)
}


// MARK: - Product Description ******
// Get attributed Description String
func getAttributedDescription(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString? {
  
  let productDescription = createDescriptionString(for: product)
  if productDescription != "" {
    let attributedDescription = productDescription.toStyleString(with: fontSize, and: .regular)
    return attributedDescription
  }
  return nil
}









