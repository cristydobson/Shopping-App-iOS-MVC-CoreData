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

  }
  
  override func tearDownWithError() throws {
    sut = nil
    
    try super.tearDownWithError()
  }

  
}

