//
//  CartVcTableViewDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//

import UIKit


// UITableViewDelegate, UITableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - Sections
  // 1 section
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  // MARK: - Items in section
  // All products in the Shopping Cart in 1 section
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsInShoppingCart.count
  }
  
  
  // MARK: - cellForRowAt
  // Load the Product Cell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCartCellID, for: indexPath) as! CartProductCell
    let index = indexPath.row
    
    // Become the cell's delegate
    cell.cartProductCellDelegate = self
    
    // Product to load in the current cell
    let product = itemsInShoppingCart[index]
    
    // Add the name of the product
    cell.productNameLabel.attributedText = getAttributedName(from: product,
                                                             withSize: 18)
    
    // Add the itemsInShoppingCart count
    let productInShoppingCartDict = itemsInShoppingCartIDs[index]
    let inShoppingCartCount = getSingleProductCountInShoppingCart(from: productInShoppingCartDict)
    cell.changeQuantityButton.text = "\(inShoppingCartCount)"
    cell.itemCountInShoppingCart = inShoppingCartCount
    
    // Add the price of the product
    let price = product.price.value
    let multipliedPriceValue = price.byItemCount(inShoppingCartCount)
    cell.productPriceLabel.text = multipliedPriceValue.toCurrencyFormat()
    
    /*
     Load the image of the product from a URL
     */
    if let imageURL = canCreateImageUrl(from: product) {
      
      // Attempt to load image
      let token = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          // The UI must be accessed through the main thread
          DispatchQueue.main.async {
            cell.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      
      /*
       When the cell is being reused, cancel loading the image.
       Use [unowned self] to avoid retention of self
       in the cell's onReuse() closure.
       */
      cell.onReuse = { [unowned self] in
        if let token = token {
          self.imageLoader?.cancelImageDownload(token)
        }
      }
      
    }
    
    return cell
  }
  
  
  // MARK: - Swipe Left on Cell
  // Swipe left to display "Delete" product button
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let removeItemAction = UIContextualAction(style: .normal, title: "") { action, sourceView, completionHandler in
      self.removeItemFromShoppingCart(from: indexPath.row)
      completionHandler(true)
    }
    
    removeItemAction.backgroundColor = .red
    removeItemAction.image = UIImage(systemName: "xmark")
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeItemAction])
    return swipeConfiguration
  }
  
  
  // MARK: - Cell Height
  // Set the cell's height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  
  
}
