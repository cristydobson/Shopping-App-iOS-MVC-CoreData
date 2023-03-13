//
//  TestCoreData.swift
//  ShoppableTests
//
//  Created by Cristina Dobson
//


import Foundation
import Shoppable
import CoreData


class TestCoreData: CoreDataStack {
  
  
  override init() {
    super.init()
    
    /*
     NSInMemoryStoreType keeps the data from
     being persisted in the app after testing
     is finished.
     */
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    
    let container = NSPersistentContainer(
      name: "ShoppableApp")
    
    container.persistentStoreDescriptions = [persistentStoreDescription]
    
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Error: \(error), description: \(error.userInfo)!!")
      }
    }
    
    accessStoreContainerForTesting(container)
  }
  
  
  
  
}
