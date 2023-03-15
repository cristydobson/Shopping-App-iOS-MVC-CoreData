//
//  CoreDataServiceTests.swift
//
//
//  Created by Cristina Dobson
//

import XCTest
import CoreData
@testable import Shoppable


final class CoreDataServiceTests: XCTestCase {

  
  var sut: CoreDataService!
  var coreDataStack: CoreDataStack!
  
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    coreDataStack = TestCoreData()
    sut = CoreDataService(coreDataStack: coreDataStack)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    coreDataStack = nil
    
    try super.tearDownWithError()
  }
  
  
  // MARK: - Helper Methods
  
  func getProduct() -> Product {
    let price = Price(value: 49.00, currency: "kr")
    let product = Product(
      id: "1", name: "Pretty Chair 1",
      price: price, info: nil,
      type: "chair",
      imageUrl: "https://shop.static.ingka.ikea.com/PIAimages/0462849_PE608354_S4.JPG")
    return product
  }
  
  
  // MARK: - Test Save Methods

  func testSaveNewProduct_whenProductObjectGiven() {
    // given
    let product = getProduct()
    
    // when
    let newProduct = sut.saveNewProduct(product)
    
    // then
    XCTAssertNotNil(newProduct)
    XCTAssertNotNil(newProduct.id, "id can't be nil")
    XCTAssertTrue(newProduct.id == "1")
    XCTAssertTrue(newProduct.name == "Pretty Chair 1")
    XCTAssertTrue(newProduct.type == "chair")
    XCTAssertNotNil(newProduct.price, "price can't be nil")
    XCTAssertTrue(newProduct.price == 49.00)
    XCTAssertTrue(newProduct.imgUrl == "https://shop.static.ingka.ikea.com/PIAimages/0462849_PE608354_S4.JPG")
    XCTAssertTrue(newProduct.count == 1)
    
  }
  
  func testContextIsSavedAfterAddingNewProduct() {
    
    // given
    let product = getProduct()
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      let newProduct = self.sut.saveNewProduct(product)
      XCTAssertNotNil(newProduct)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new product!!")
    }
  }
 
  
}

