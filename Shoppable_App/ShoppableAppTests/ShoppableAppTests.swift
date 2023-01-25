//
//  ShoppableAppTests.swift
//  ShoppableAppTests
//
//  Created by Cristina Dobson on 1/23/23.
//

import XCTest
@testable import Shoppable

final class ShoppableAppTests: XCTestCase {
  
  var subject: ProductCatalogViewController!
  var subjectTwo: ProductInformation!

  override func setUpWithError() throws {
    
    try super.setUpWithError()
    
    subject = ProductCatalogViewController()
    subjectTwo = ProductInformation()
    
    //Populating the array of products
    subject.productList = [
      //Chair
      [
        ProductDataKeys.id.rawValue : "1" as AnyObject,
        ProductDataKeys.name.rawValue : "Henriksdal" as AnyObject,
        ProductDataKeys.price.rawValue : [
          ProductDataKeys.value.rawValue : 499 as AnyObject,
          ProductDataKeys.currency.rawValue : "kr" as AnyObject
        ] as AnyObject,
        ProductDataKeys.info.rawValue : [
          ProductDataKeys.material.rawValue : "wood with cover" as AnyObject,
          ProductDataKeys.color.rawValue : "white" as AnyObject
        ] as AnyObject,
        ProductDataKeys.type.rawValue : "chair" as AnyObject,
        ProductDataKeys.imageUrl.rawValue : "https://shop.static.ingka.ikea.com/PIAimages/0462849_PE608354_S4.JPG" as AnyObject
      ],
      //Couch
      [
        ProductDataKeys.id.rawValue : "2" as AnyObject,
        ProductDataKeys.name.rawValue : "Lidhult" as AnyObject,
        ProductDataKeys.price.rawValue : [
          ProductDataKeys.value.rawValue : 1035 as AnyObject,
          ProductDataKeys.currency.rawValue : "kr" as AnyObject
        ] as AnyObject,
        ProductDataKeys.info.rawValue : [
          ProductDataKeys.numberOfSeats.rawValue : 4 as AnyObject,
          ProductDataKeys.color.rawValue : "beige" as AnyObject
        ] as AnyObject,
        ProductDataKeys.type.rawValue : "couch" as AnyObject,
        ProductDataKeys.imageUrl.rawValue : "https://shop.static.ingka.ikea.com/PIAimages/0667779_PE714073_S4.JPG" as AnyObject
      ]
    ]
    
    //Populating the shopping cart array from UserDefaults
    subject.itemsInShoppingCartIDs = [
      [
        UserDefaultsKeys.id.rawValue : "1" as AnyObject,
        UserDefaultsKeys.inShoppingCartCount.rawValue : 6 as AnyObject,
        UserDefaultsKeys.productCollectionType.rawValue : "chair" as AnyObject
      ],
      [
        UserDefaultsKeys.id.rawValue : "2" as AnyObject,
        UserDefaultsKeys.inShoppingCartCount.rawValue : 2 as AnyObject,
        UserDefaultsKeys.productCollectionType.rawValue : "couch" as AnyObject
      ]
    ]
  }
  
  override func tearDownWithError() throws {
    subject = nil
    subjectTwo = nil
    
    try super.tearDownWithError()
  }
  
  func testGettingProductNameFromDictionary() {
    let product = subject.productList.first!
    XCTAssertEqual(subjectTwo.getProductName(from: product), "Henriksdal")
  }
  
  func testGettingProductInfoFromDictionary() {
    let product = subject.productList.first!
    XCTAssertNotNil(subjectTwo.getProductInfo(from: product))
  }
  
  func testGettingProductInfoKeysFromDictionary() {
    let product = subject.productList.first!
    let productInfo = product[ProductDataKeys.info.rawValue] as! ProductDictionary
    XCTAssertEqual(subjectTwo.getProductInfoKeys(from: productInfo).count, 2)
  }
  
  func testCreatingDescriptionStringForChairFromInfoKeys() {
    let product = subject.productList.first!
    let productInfo = product[ProductDataKeys.info.rawValue] as! ProductDictionary
    let infoKeys = subjectTwo.getProductInfoKeys(from: productInfo)
    XCTAssertEqual(subjectTwo.createDescriptionString(with: infoKeys, from: productInfo), "wood with cover, white")
  }
  
  func testCreatingDescriptionStringForCouchFromInfoKeys() {
    let product = subject.productList.last!
    let productInfo = product[ProductDataKeys.info.rawValue] as! ProductDictionary
    let infoKeys = subjectTwo.getProductInfoKeys(from: productInfo)
    XCTAssertEqual(subjectTwo.createDescriptionString(with: infoKeys, from: productInfo), "4 seats, beige")
  }
  
  
  func testGettingProductPriceFromDictionary() {
    let product = subject.productList.first!
    XCTAssertEqual(subjectTwo.getProductPrice(from: product), 499.0)
  }

  func testGettingProductPriceCurrencyFromDictionary() {
    let product = subject.productList.first!
    XCTAssertEqual(subjectTwo.getProductPriceCurrency(from: product), "kr")
  }
  
  func testGettingProductCountInShoppingCart() {
    let product = subject.productList.first!
    let productsInShoppingCartIdsArray = subject.itemsInShoppingCartIDs
    XCTAssertEqual(subjectTwo.getProductCountInShoppingCart(for: product, from: productsInShoppingCartIdsArray), 6)
  }

}

