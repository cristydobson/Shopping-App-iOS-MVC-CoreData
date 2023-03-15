/*
 CoreDataStack.swift
 
 Created by Cristina Dobson
 */


import Foundation
import CoreData


class CoreDataStack {
  
  
  // MARK: - Properties
  
  static let modelName = "ShoppableApp"
  
  static var managedObjectModel: NSManagedObjectModel = {
    
    guard let bundleURL = Bundle.main.url(
      forResource: CoreDataStack.modelName,
      withExtension: "momd") else {
      fatalError("Failed to locate momd file")
    }
    
    guard let model = NSManagedObjectModel(contentsOf: bundleURL) else {
      fatalError("Failed to load momd file")
    }
    
    return model
  }()
  
  var storeContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(
      name: CoreDataStack.modelName,
      managedObjectModel: CoreDataStack.managedObjectModel)
    
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
 
  
}
