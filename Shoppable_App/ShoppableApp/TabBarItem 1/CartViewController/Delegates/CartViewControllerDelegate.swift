//
//  CartViewControllerDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//

import Foundation


// CartViewController Delegate
protocol CartViewControllerDelegate: AnyObject {
  
  func didTapRemoveItemFromCartController(_ count: Int,
                                          from index: Int)
  
  func didUpdateItemQuantityFromCartController(_ count: Int,
                                               with updatedArray: [ProductDictionary])
  
  // Called in the "Add To Cart" observer
  func updateItemsInShoppingCartIDs(
    on viewController: CartViewController
  )
  
}
