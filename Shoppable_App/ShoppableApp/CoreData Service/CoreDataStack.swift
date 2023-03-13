/*
 CoreDataStack.swift
 
 Created by Cristina Dobson
 */


import Foundation
import CoreData


class CoreDataStack {
  
  
  // MARK: - Properties
  
  private let modelName = "ShoppableApp"
  
  private lazy var storeContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { _, error in
      
      if let error = error as NSError? {
        print("Error: \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  lazy var managedContext: NSManagedObjectContext = {
    return storeContainer.viewContext
  }()
  
  
  // MARK: - Methods
  
  init() {}
  
  func saveContext() {
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    }
    catch let error as NSError {
      print("Error: \(error), \(error.userInfo)")
    }
  }
  
  
  func accessStoreContainerForTesting(_ container: NSPersistentContainer) {
    storeContainer = container
  }
  
}
