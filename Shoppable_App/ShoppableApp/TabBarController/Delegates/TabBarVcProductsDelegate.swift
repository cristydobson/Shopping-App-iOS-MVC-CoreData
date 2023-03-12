//
//  TabBarVcProductsDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductOverviewViewControllerDelegate

extension TabBarController: ProductOverviewViewControllerDelegate {
  
  
  // MARK: - Update CartViewController
  
  /*
   The user has added new items to the Shopping Cart from
   ProductCatalogViewController or ProductPageViewController
   */
  func updateCartControllerFromProductCatalogController(with product: Product) {
    
    // Store the IDs of the products in the Shopping Cart in UserDefaults
    
    let productID = product.id
    var itemIsInShoppingCart = false
    
    /*
     Loop throught the local variable array itemsInShoppingCartIDs
     to check if the item is already in the Shopping Cart
     */
    for i in 0..<itemsInShoppingCartIDs.count {
      
      let item = itemsInShoppingCartIDs[i]
      if
        let itemID = item[UserDefaultsKeys.id.rawValue] as? String,
        itemID == productID
      {
        itemIsInShoppingCart = true
        
        /*
         Update the local variable array itemsInShoppingCartIDs
         with the new count of the product
         */
        updateItemCountInShoppingCart(on: i)
        
        break
      }
    }
    
    /*
     If the product is not in the Shopping Cart already,
     then append it as a new item to the local array itemsInShoppingCartIDs,
     and save it to UserDeafults as well
     */
    if !itemIsInShoppingCart {
      saveNewItemInShoppingCart(with: productID, type: product.type)
    }
    
    // Update the Cart TabBar item's badge
    itemsInShoppingCartCount += 1
    setupCartTabBarItemBadge(with: itemsInShoppingCartCount)
    
    // Update the total price in Shopping Cart in UserDefaults
    let price = product.price.value
    ShoppingCartTotalPriceHelper.updateTheShoppingCartTotal(with: price)
    
  }
  
  
  // MARK: - Update Item Count in Shopping Cart
  
  func updateItemCountInShoppingCart(on index: Int) {
    if let inShoppingCartCount = itemsInShoppingCartIDs[index][UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int
    {
      let updatedCount = inShoppingCartCount + 1
      
      itemsInShoppingCartIDs[index].updateValue(
        updatedCount as AnyObject,
        forKey: UserDefaultsKeys.inShoppingCartCount.rawValue)
      
      ShoppingCartProductHelper.saveShoppingCartProductsInUserDefaults(
        itemsInShoppingCartIDs)
    }
  }
  
  
  // MARK: - Save new item in Shopping Cart
  
  func saveNewItemInShoppingCart(with id: String, type: String) {
    let productIdDictionary: ProductDictionary = [
      UserDefaultsKeys.id.rawValue:id as AnyObject,
      UserDefaultsKeys.type.rawValue:type as AnyObject,
      UserDefaultsKeys.inShoppingCartCount.rawValue:1 as AnyObject
    ]
    itemsInShoppingCartIDs.append(productIdDictionary)
    
    ShoppingCartProductHelper.saveShoppingCartProductsInUserDefaults(
      itemsInShoppingCartIDs)
  }
}
