//
//  CartViewControllerTests.swift
//  ShoppableTests
//
//  Created on 2/8/23.
//

import XCTest
@testable import Shoppable

final class CartViewControllerTests: XCTestCase {

  
  var sut: CartViewController!
  
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    sut = CartViewController()
    
    // Product in Shopping Cart
    sut.itemsInShoppingCartIDs = [
      [
        UserDefaultsKeys.id.rawValue : "1" as String,
        UserDefaultsKeys.type.rawValue: "chair" as String,
        UserDefaultsKeys.inShoppingCartCount.rawValue: 3 as Int
      ] as [String:AnyObject],
      [
        UserDefaultsKeys.id.rawValue : "4" as String,
        UserDefaultsKeys.type.rawValue: "couch" as String,
        UserDefaultsKeys.inShoppingCartCount.rawValue: 1 as Int
      ] as [String:AnyObject]
    ]
    
    // Product Collection
    let productCollections = [
      ProductCollection(
        type: "chair",
        products: [
          Product(id: "1", name: "Pretty Chair 1",
                  price: Price(value: 49.90, currency: "kr"),
                  info: Info(material: "wood with cover", numberOfSeats: nil, color: "white"),
                  type: "chair",
                  imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0462849_PE608354_S4.JPG"
                 ),
          Product(id: "8", name: "Pretty Chair 3",
                  price: Price(value: 49.90, currency: "kr"),
                  info: Info(material: "wood and metal", numberOfSeats: nil, color: "black"),
                  type: "chair",
                  imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0724693_PE734575_S4.JPG"
                 )
        ]
      ),
      ProductCollection(
        type: "couch",
        products: [
          Product(id: "4", name: "Comfy Couch 3",
                  price: Price(value: 749.50, currency: "kr"),
                  info: Info(material: nil, numberOfSeats: 2, color: "black"),
                  type: "couch",
                  imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0320948_PE514802_S4.JPG"
                 )
        ]
      )
    ]
    sut.productCollections = productCollections
  }
  
  override func tearDownWithError() throws {
    sut = nil
    
    try super.tearDownWithError()
  }
  
  
  // MARK: - Given
  
  func givenItemsInShoppingCartIDs() -> [ProductDictionary] {
    return sut.itemsInShoppingCartIDs
  }
  
  func givenCollections() -> [ProductCollection] {
    return sut.productCollections
  }
  

  // MARK: - Get values from itemsInShoppingCartIDs
  
  func testGetShoppingCartItemID_returnsString() {
    // given
    let product = givenItemsInShoppingCartIDs()[0]
    let expectedID = product[UserDefaultsKeys.id.rawValue] as? String
    
    // when
    let idString = getShoppingCartItemID(from: product)
    
    // then
    XCTAssertEqual(idString, expectedID)
  }
  
  func testGetShoppingCartItemType_returnsString() {
    // given
    let product = givenItemsInShoppingCartIDs()[1]
    let expectedType = product[UserDefaultsKeys.type.rawValue] as? String
    
    // when
    let typeString = getShoppingCartItemType(from: product)
    
    // then
    XCTAssertEqual(typeString, expectedType)
  }
  
  func testGetSingleProductCountInShoppingCart_returnsInt() {
    // given
    let product = givenItemsInShoppingCartIDs()[0]
    let expectedCount = product[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int
    
    // when
    let countString = getSingleProductCountInShoppingCart(from: product)
    
    // then
    XCTAssertEqual(countString, expectedCount)
  }
  
  
  // MARK: - Find the ItemInShoppingCart in the Product Collections
  
  func testGetProductCollection_withCorrectProductType() {
    // given
    let productType = CollectionType.chair.rawValue
    
    // when
    let returnedCollection = getProductCollection(from: givenCollections(),
                                                  of: productType)!
    
    // then
    XCTAssertEqual(returnedCollection.type, productType)
    
  }
  
  func testGetProductFromShoppingCart_withSameID_inProductCollection() {
    // given
    let productCollection = givenCollections().first!
    let productID = productCollection.products.last!.id //"8"
    
    // when
    let returnedProduct = getProductFromShoppingCartIn(in: productCollection, for: productID)!
    
    // then
    XCTAssertEqual(returnedProduct.id, productID)
  }
  
  func testGetProductsFromShoppingCart_returnProductArray() {
    // when
    let array = getProductsInShoppingCart(givenItemsInShoppingCartIDs(),
                                          from: givenCollections())
    
    // then
    XCTAssertTrue(array.count == 2)
  }
  
  
  // MARK: - Update Shopping Cart count
  
  //Update the product's count on the ShoppingCart array
  func testUpdateProductCountInShoppingCart_withNewValue() {
    // given
    let index = 0
    let newCount = 5

    // when
    sut.updateProductCountInShoppingCart(newCount, on: index)
    
    // then
    let updatedCount = givenItemsInShoppingCartIDs()[index][UserDefaultsKeys.inShoppingCartCount.rawValue] as! Int
    XCTAssertEqual(updatedCount, newCount)
    
  }
  
}

