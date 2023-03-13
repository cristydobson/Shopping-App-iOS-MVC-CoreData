/*
 CoreDataStack.swift
 
 Created by Cristina Dobson
 */


import Foundation
import CoreData


class CoreDataStack {
  
  
  // MARK: - Properties
  
  private let modelName: String
  
  private lazy var storeContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { _, error in
      
      if let error = error as NSError? {
        print("Error: \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  
  // MARK: - Methods
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  func saveContext() {
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    }
    catch let error as NSError {
      print("Error: \(error), \(error.userInfo)")
    }
  }
  
}
