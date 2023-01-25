/*
 JsonLoader.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/24/23.
 
 Load the data from the "products.json" file
 */

import Foundation

class JsonLoader {
  
  //MARK: - Load JSON Data
  func loadJsonData(from fileName: String) -> [ProductDictionary] {
    
    var data: Data
    
    //Find the JSON file
    if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        data = try Data(contentsOf: path)
      }
      catch {
        print("ERROR loading JSON data: \(fileName), with error: \(error.localizedDescription)")
        return []
      }
      
      do {
        //Check if it's possible to get the JSON data
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
          let productsDataDict = (json[ProductDataKeys.products.rawValue] as! [ProductDictionary])
          return productsDataDict
        }
      }
      catch let error {
        print("ERROR: \(error.localizedDescription)")
      }
    }
    return []
  }
  
  //Create a set of products for every product type
  func returnProductCollectionTypeArray(from fileName: String) -> [ProductDictionary] {
    let array = loadJsonData(from: fileName)
    
    //Loop through the enum CollectionType
    let collectionTypes = CollectionType.allCases
    var productCollections: [ProductDictionary] = []
    for type in collectionTypes {
      let typeRawValue = type.rawValue
      
      //Only get the products that match the product type
      let newArr = array.filter {
        $0[ProductDataKeys.type.rawValue] as! String == typeRawValue
      }
      let productDict: ProductDictionary = [
        ProductDataKeys.type.rawValue : typeRawValue as AnyObject,
        ProductDataKeys.products.rawValue : newArr as AnyObject
      ]
      productCollections.append(productDict)
    }
    return productCollections
  }
  
  
}




