/*
 ProductInformation.swift
 ShoppableApp
 
 Created on 1/23/23.
 
 Methods to get the product information from
 a Product object
 */

import Foundation


//MARK: - Product Name ******

func getAttributedName(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
  let name = product.name.uppercased()
  return name.toStyledString(with: fontSize, and: .bold)
}


//MARK: - Product Price ******

//Get attributed Price String
func getAttributedPrice(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString {
  let currency = product.price.currency
  let formattedPrice = product.price.value.toCurrencyFormat(in: currency)
  return formattedPrice.toCurrencyAttributedString(with: fontSize)
}


//MARK: - Product Description ******
//Create the description string of a product
func createDescriptionString(for product: Product) -> String {
  
  var resultString = ""
  
  if let productInfo = product.info {
    
    if let material = productInfo.material {
      resultString = NSLocalizedString(material, comment: "Material of the chair") +
      ", "
      resultString.capitalizeFirstLetter()
    }
    else if let seats = productInfo.numberOfSeats {
      resultString =
      "\(seats) " +
      NSLocalizedString("seats", comment: "Seat count of a couch") +
      ", "
    }
    
    if let color = product.info?.color {
      resultString += NSLocalizedString(color, comment: "Color of the product")
    }
  }
  
  return resultString
}

//Get attributed Description String
func getAttributedDescription(from product: Product, withSize fontSize: CGFloat) -> NSAttributedString? {
  let productDescription = createDescriptionString(for: product)
  if productDescription != "" {
    let attributedDescription = productDescription.toStyledString(with: fontSize, and: .regular)
    return attributedDescription
  }
  return nil
}


//MARK: - Product ImageURL ******

//Can create the imageURL to load the image
func canCreateImageUrl(from product: Product) -> URL? {
  if
    let productImageUrlString = product.imageUrl,
    let productImageURL = URL(string: productImageUrlString)
  {
    return productImageURL
  }
  
  return nil
}


//MARK: - Product Type ******

//Get the product collection type localized name
func getProductCollectionTypeLocalizedName(from index: Int) -> String {
  
  let collectionTypeCases = CollectionType.allCases
  if index <= collectionTypeCases.count-1 {
    let collectionName = collectionTypeCases[index].productTypeTitle
    return NSLocalizedString(collectionName,
                             comment: "Collection type")
  }
  
  return ""
}
