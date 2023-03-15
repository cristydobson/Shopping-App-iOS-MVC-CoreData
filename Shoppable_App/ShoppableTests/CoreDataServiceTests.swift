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
  
  
  // MARK: - Test Save New Product

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
      
      // then
      XCTAssertNotNil(newProduct)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new product!!")
    }
  }
  
  
  // MARK: - Test Update Single Product Count
  
  func testContextIsSavedAfterUpdateCountForProduct_withPositiveNumber() {
    // given
    let product = getProduct()
    let newProduct = sut.saveNewProduct(product)
    let expectedCount = 2
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.updateCount(for: newProduct, with: 2)
      
      // then
      XCTAssertEqual(Int(newProduct.count), expectedCount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new count for product!!")
    }
  }
  
  func testContextIsSavedAfterUpdateCountForProduct_byPositiveNumber() {
    // given
    let product = getProduct()
    // Start count is 1
    let newProduct = sut.saveNewProduct(product)
    let expectedCount = 3
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.updateCount(for: newProduct, by: 2)
      
      // then
      XCTAssertEqual(Int(newProduct.count), expectedCount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new count for product by positive number!!")
    }
  }
  
  func testContextIsSavedAfterUpdateCountForProduct_byNegativeNumber() {
    // given
    let product = getProduct()
    // Start count is 1
    let newProduct = sut.saveNewProduct(product)
    let expectedCount = 1
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      /*
       If the product's count is n,
       then it can't subtract n in CartController
       ChangeQuantity pickerView.
       For the test, first increment 1 to 2.
       Then test update by a negative number.
       */
      self.sut.updateCount(for: newProduct, by: 1)
      self.sut.updateCount(for: newProduct, by: -1)
      
      // then
      XCTAssertEqual(Int(newProduct.count), expectedCount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new count for product by negative number!!")
    }
  }
  
  
  // MARK: - Test Delete Product
  
  func testContextIsSavedAfterDeletingProduct() {
    // given
    let product = getProduct()
    let newProduct = sut.saveNewProduct(product)
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.deleteProduct(newProduct)
      
      // then
      XCTAssertNil(newProduct.shoppingCart)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save delete product!!")
    }
  }
  
  
  // MARK: - Test Create New Shopping Cart
  func testContextIsSavedAfterGetShoppingCart_whenShoppingCartDoesNotExist_thenCreateNewOne() {
    // given
    let newCartName = "TestShoppingCart"
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      let newShoppingCart = self.sut.getShoppingCart(newCartName)
      
      // then
      XCTAssertNotNil(newShoppingCart)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not save new Shopping Cart!!")
    }
  }
  
  
  // MARK: - Test Update Shopping Cart
  
  func testContextIsSavedAfterUpdateTotalAmount_inShoppingCart_byPositiveDouble() {
    // given
    let shoppingCart = sut.shoppingCart
    let expectedTotalAmount = 100.0

    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }

    // when
    coreDataStack.managedContext.perform {
      self.sut.updateShoppingCartTotalAmount(by: 100.0)

      // then
      XCTAssertEqual(shoppingCart!.totalAmount, expectedTotalAmount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not update Shopping Cart's total amount!!")
    }
  }
  
  func testContextIsSavedAfterUpdateTotalAmount_inShoppingCart_byNegativeDouble() {
    // given
    let shoppingCart = sut.shoppingCart
    let expectedTotalAmount = 80.0
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.updateShoppingCartTotalAmount(by: 100.0)
      self.sut.updateShoppingCartTotalAmount(by: -20.0)
      
      // then
      XCTAssertEqual(shoppingCart!.totalAmount, expectedTotalAmount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not update Shopping Cart's total amount by a negative number!!")
    }
  }
  
  func testContextIsSavedAfterUpdateProductCount_inShoppingCart_byPositiveNumber() {
    // given
    let shoppingCart = sut.shoppingCart
    let expectedCount = 5
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.updateShoppingCartProductCount(by: 5)
      
      // then
      XCTAssertEqual(Int(shoppingCart!.productCount), expectedCount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not update Shopping Cart's product count!!")
    }
  }
  
  func testContextIsSavedAfterUpdateProductCount_inShoppingCart_byNegativeNumber() {
    // given
    let shoppingCart = sut.shoppingCart
    let expectedCount = 2
    
    expectation(forNotification: .NSManagedObjectContextDidSave,
                object: coreDataStack.managedContext) { _ in
      return true
    }
    
    // when
    coreDataStack.managedContext.perform {
      self.sut.updateShoppingCartProductCount(by: 5)
      self.sut.updateShoppingCartProductCount(by: -3)
      
      // then
      XCTAssertEqual(Int(shoppingCart!.productCount), expectedCount)
    }
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Did not update Shopping Cart's product count by a negative number!!")
    }
  }
  

}

