//
//  CartViewControllerTests.swift
//  ShoppableTests
//
//  Created on 2/8/23.
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
  
  
  // MARK: - Test Save Methods

 
  
 
  
}

