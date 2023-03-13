//
//  CartVcCellDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// CartProductCellDelegate

extension CartViewController: CartProductCellDelegate {
  
  
  // MARK: - Did Remove Item
  
  // The user tapped "Remove Item" on the cell's "Options" button menu
  func didRemoveItemFromShoppingCart(from cell: CartProductCell) {
    
    // Find the product index before removing it
    if let index = shoppingCartTableView.indexPath(for: cell)?.row {
      removeItemFromShoppingCart(from: index)
    }
  }
  
  
  // MARK: - Did Change Product Quantity
  
  // The user tapped on the changeQuantity button to display the pickerView
  func didTapChangeQuantityButton(from cell: CartProductCell) {
    
    /*
     Attach the pickerView and its toolBar to the
     changeQuantityButton
     */
    addPickerViewToChangeQuantityButton(for: cell)
    
    // Display a blurred background view
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    
    /*
     Store the current cell's indexPath to be able
     to update its product count in the Shopping Cart later
     */
    changedQuantityOnCellIndexPath = shoppingCartTableView.indexPath(for: cell)
    
    // Show the product count in the PickerView
    if let cellValue = Int(cell.changeQuantityButton.text!) {
      quantityPickerView?.selectRow(
        cellValue-1, inComponent: 0, animated: false)
    }
  }
  
  
  // MARK: - Add PickerView to Cell
  
  /*
   Attach the pickerView and its toolBar to the
   changeQuantityButton textfield
   */
  func addPickerViewToChangeQuantityButton(for cell: CartProductCell) {
    
    if quantityPickerView == nil { setupQuantityPickerView() }
    cell.changeQuantityButton.inputView = quantityPickerView
    cell.changeQuantityButton.inputAccessoryView = quantityPickerView?.pickerToolBar
  }
}
