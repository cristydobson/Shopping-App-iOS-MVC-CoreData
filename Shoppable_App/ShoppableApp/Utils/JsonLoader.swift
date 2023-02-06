/*
 JsonLoader.swift
 ShoppableApp
 
 Created on 1/24/23.
 
 Load the data from the "products.json" file
 */

import Foundation


//MARK: - Product Structs ******
struct ProductInformation: Decodable {
  let products: [Product]
}

struct Product: Decodable {
  let id: String
  let name: String
  let price: Price
  let info: Info?
  let type: String
  let imageUrl: String?
}

struct Price: Decodable {
  let value: Double
  let currency: String
}

struct Info: Decodable {
  let material: String?
  let numberOfSeats: Int?
  let color: String?
}

struct ProductCollection {
  let type: String
  let products: [Product]
}

struct JsonLoader {
  
  //MARK: - Load JSON Data ******
  func decodingJsonData(from fileName: String) -> ProductInformation?  {
    
    var data: Data
    
    //Find the JSON file
    if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        data = try Data(contentsOf: path)
      }
      catch {
        print("ERROR loading JSON data: \(fileName), with error: \(error.localizedDescription)")
        return nil
      }
      
      do {
        let decoder = JSONDecoder()
        let information = try decoder.decode(ProductInformation.self, from: data)
        return information
        
      }
      catch let error {
        print("ERROR: \(error.localizedDescription)")
        return nil
      }
    }
    return nil
  }
  
  
  //MARK: - Return Product Collections ******
  //Create a set of products for every product type
  func returnProductCollectionTypeArray(from fileName: String) -> [ProductCollection] {
    
    if let infoArray = decodingJsonData(from: fileName) {
      
      let array = infoArray.products
      
      //Loop through the enum CollectionType
      let collectionTypes = CollectionType.allCases
      var productCollections: [ProductCollection] = []
      for type in collectionTypes {
        let typeRawValue = type.rawValue
        
        //Only get the products that match the product type
        let newArr = array.filter {
          $0.type == typeRawValue
        }
        
        let collection = ProductCollection(
          type: typeRawValue,
          products: newArr
        )
        productCollections.append(collection)
      }
      return productCollections
    }
    
    return []
  }
  
  
}





