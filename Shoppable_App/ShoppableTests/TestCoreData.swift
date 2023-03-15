//
//  TestCoreData.swift
//  ShoppableTests
//
//  Created by Cristina Dobson on 3/15/23.
//

import Foundation
import CoreData
@testable import Shoppable

class TestCoreData: CoreDataStack {
  
  override init() {
    super.init()
    
    let storeDescription = NSPersistentStoreDescription()
    storeDescription.type = NSInMemoryStoreType
    
    let container = NSPersistentContainer(
      name: CoreDataStack.modelName,
      managedObjectModel: CoreDataStack.managedObjectModel)
    container.persistentStoreDescriptions = [storeDescription]
    
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Error: \(error), description: \(error.userInfo)!!")
      }
    }
    
    storeContainer = container
    
  }
  
}
