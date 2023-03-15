//
//  CoreDataHelper.swift
//  
//
//  Created by Cristina Dobson
//


import Foundation
import CoreData


final class CoreDataService {
  
  
  // MARK: - Properties
  
  let coreDataStack: CoreDataStack
  var shoppingCart: ShoppingCart!
  
  
  // MARK: - Init Methods
  
  init(coreDataStack: CoreDataStack) {
    self.coreDataStack = coreDataStack
    loadShoppingCart()
  }
  
  func loadShoppingCart() {
    shoppingCart = getShoppingCart()
  }
  
}


// MARK: - Getter Methods

extension CoreDataService {
  
  func getShoppingCart() -> ShoppingCart? {
    
    let cartName = "ShoppingCart"
    
    let cartFetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
    cartFetchRequest.predicate = NSPredicate(
      format: "name == %@", cartName)
    
    do {
      let results = try coreDataStack.managedContext.fetch(cartFetchRequest)
      
      var shoppingCart: ShoppingCart
      
      if results.count > 0 {
        shoppingCart = results.first!
      }
      else {
        shoppingCart = ShoppingCart(context: coreDataStack.managedContext)
        shoppingCart.name = cartName
        coreDataStack.saveContext()
      }
      return shoppingCart
    }
    catch let error as NSError {
      print("Error fetching ShoppingCart: \(error), description: \(error.userInfo)!!")
    }
    
    return nil
  }
  
  func getShoppingCartCount() -> Int {
    return Int(shoppingCart.productCount)
  }
  
  func getShoppingCartTotalAmount() -> Double {
    return shoppingCart.totalAmount
  }
  
  func getProduct(_ id: String, from products: [ShoppingCartProduct]) -> ShoppingCartProduct? {
    
    for product in products {
      if product.id == id {
        return product
      }
    }
    return nil
  }
  
  func getProductArray() -> [ShoppingCartProduct] {
    return shoppingCart.products?.allObjects as! [ShoppingCartProduct]
  }
  
}


// MARK: - Save Methods

extension CoreDataService {
  
  // MARK: - ShoppingCartProduct
  
  func saveNewProduct(_ product: Product) -> ShoppingCartProduct {
    
    let newProduct = ShoppingCartProduct(context: coreDataStack.managedContext)
    newProduct.id = product.id
    newProduct.name = product.name
    newProduct.type = product.type
    newProduct.price = product.price.value
    newProduct.imgUrl = product.imageUrl
    newProduct.count = 1
    
    shoppingCart.addToProducts(newProduct)
    
    coreDataStack.saveContext()
    return newProduct
  }
  
  func updateCount(for product: ShoppingCartProduct, with count: Int) {
    product.count = Int64(count)
    coreDataStack.saveContext()
  }
  
  func updateCount(for product: ShoppingCartProduct, by count: Int) {
    product.count += Int64(count)
    coreDataStack.saveContext()
  }
  
  func deleteProduct(_ product: ShoppingCartProduct) {
    coreDataStack.managedContext.delete(product)
    coreDataStack.saveContext()
  }
  
  
  // MARK: - ShoppingCart
  
  func updateTotalAmount(by amount: Double) {
    shoppingCart.totalAmount += amount
    coreDataStack.saveContext()
  }
  
  func updateProductCount(by count: Int) {
    shoppingCart.productCount += Int64(count)
    coreDataStack.saveContext()
  }
  
}

