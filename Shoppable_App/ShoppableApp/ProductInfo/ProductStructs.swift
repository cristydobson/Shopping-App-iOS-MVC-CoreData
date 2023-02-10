//
//  ProductStructs.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// MARK: - Product Array ******

struct ProductInformation: Decodable {
  let products: [Product]
}


// MARK: - Product Object ******

struct Product: Decodable {
  let id: String
  let name: String
  let price: Price
  let info: Info?
  let type: String
  let imageUrl: String?
}


// MARK: - Product's Price ******

struct Price: Decodable {
  let value: Double
  let currency: String
}


// MARK: - Product's Info ******

struct Info: Decodable {
  let material: String?
  let numberOfSeats: Int?
  let color: String?
}


// MARK: - Product Collection ******

struct ProductCollection {
  let type: String
  let products: [Product]
}





