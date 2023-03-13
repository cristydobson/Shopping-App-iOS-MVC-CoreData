//
//  ProductModels.swift
//
//
//  Created by Cristina Dobson
//


// MARK: - Product Array

struct ProductInformation: Codable {
  let products: [Product]
}


// MARK: - Product Object

struct Product: Codable {
  let id: String
  let name: String
  let price: Price
  let info: Info?
  let type: String
  let imageUrl: String?
}


// MARK: - Product's Price

struct Price: Codable {
  let value: Double
  let currency: String
}


// MARK: - Product's Info

struct Info: Codable {
  let material: String?
  let numberOfSeats: Int?
  let color: String?
}


// MARK: - Product Collection 

struct ProductCollection {
  let type: String
  let products: [Product]
}





