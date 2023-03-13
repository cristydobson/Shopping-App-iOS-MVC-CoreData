//
//  CartVcObservers.swift
//
//
//  Created by Cristina Dobson
//

import Foundation


// "Add To Cart" Observer

extension CartViewController {
  
  
  // MARK: - Setup Observer
  /*
   Add an Observer to update the CartViewController data and UI when
   other ViewControllers have changed the item count in the
   Shopping Cart.
   */
  func setupCartUpdateOberserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didUpdateShoppingCart(_:)),
      name: Notification.Name(updateShoppingCartObserverName),
      object: nil
    )
  }
  
  
  // MARK: - Observer Action
  /*
   The observer setup in ViewDidLoad() calls this method when
   the products in the Shopping Cart have been updated
   elsewhere
   */
  @objc func didUpdateShoppingCart(_ notification: Notification) {
    cartViewControllerDelegate?.updateProductsInShoppingCart(on: self)
    reloadShoppingTableView = true
  }
}
