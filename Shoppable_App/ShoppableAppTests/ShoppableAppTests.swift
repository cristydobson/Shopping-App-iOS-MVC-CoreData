//
//  ShoppableAppTests.swift
//  ShoppableAppTests
//
//  Created on 1/23/23.
//

import XCTest
@testable import Shoppable

final class ShoppableAppTests: XCTestCase {
  
  var subject: ProductCatalogViewController!

  override func setUpWithError() throws {
    
    try super.setUpWithError()
    
    subject = ProductCatalogViewController()
    
    //Populating the array of products
    subject.productList = [
      //Chair
      Product(
        id: "1",
        name: "Pretty Chair",
        price: Price(value: 49.90, currency: "kr"),
        info: Info(material: "wood with cover", numberOfSeats: nil, color: "white"),
        type: "chair",
        imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0462849_PE608354_S4.JPG"
      ),
      //Couch
      Product(
        id: "2",
        name: "Comfy Couch",
        price: Price(value: 103.50, currency: "kr"),
        info: Info(material: nil, numberOfSeats: 4, color: "beige"),
        type: "couch",
        imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0667779_PE714073_S4.JPG"
      )
    ]
  }
  
  override func tearDownWithError() throws {
    subject = nil
    
    try super.tearDownWithError()
  }
  
  func testGettingProductName() {
    let product = subject.productList.first!
    XCTAssertEqual(product.name, "Pretty Chair")
  }
  
  func testCreatingDescriptionStringForChair() {
    let product = subject.productList.first!
    XCTAssertEqual(createDescriptionString(for: product), "wood with cover, white")
  }
  
  func testCreatingDescriptionStringForCouch() {
    let product = subject.productList.last!
    XCTAssertEqual(createDescriptionString(for: product), "4 seats, beige")
  }
  
  func testGettingProductPrice() {
    let product = subject.productList.first!
    XCTAssertEqual(product.price.value, 49.90)
  }

  func testGettingProductPriceCurrency() {
    let product = subject.productList.first!
    XCTAssertEqual(product.price.currency, "kr")
  }

}

