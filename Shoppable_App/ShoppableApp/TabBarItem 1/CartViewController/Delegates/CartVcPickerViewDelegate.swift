//
//  CartVcPickerViewDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// QuantityPickerViewDelegate
extension CartViewController: QuantityPickerViewDelegate {
  
  
  // MARK: - ToolBar Done button
  
  // User Tapped "Done" on the PickerView
  func didTapDoneButtonOnToolBar() {
    tappedDoneButtonOnPicker()
  }
  
  /*
   Action triggered when the pickerView's
   toolBar button "Done" is tapped
   */
  func tappedDoneButtonOnPicker() {
    
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      // Dismiss the PickerView
      cell.changeQuantityButton.resignFirstResponder()
      
      // Hide the background BlurView
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
      
      // Check if the product quantity has changed
      checkProductQuantityUpdate(for: cell, on: cellIndexPath.row)
      
      // Remover the PickerView and its ToolBar from the cell
      removePickerViewFromCell(cell)
    }
  }
  
  
  // MARK: - ToolBar Cancel button
  
  // User Tapped "Cancel" on the PickerView
  func didTapCancelButtonOnToolBar() {
    dismissPickerView()
  }
  
  /*
   Called when the PickerView's "Cancel" button is tapped
   or the blurView is tapped to dismiss the PickerView
   */
  func dismissPickerView() {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      // Dismiss the PickerView
      cell.changeQuantityButton.resignFirstResponder()
      
      // Update product count in the cell
      cell.newPickerValue = 0
      
      // Hide the background BlurView
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
      
      // Remover the PickerView and its ToolBar from the cell
      removePickerViewFromCell(cell)
    }
  }
  
  // Remover the PickerView and its ToolBar from the cell
  func removePickerViewFromCell(_ cell: CartProductCell) {
    cell.changeQuantityButton.inputView = nil
    cell.changeQuantityButton.inputAccessoryView = nil
  }
  
  
  // MARK: - PickerView updates
  
  // User updated the product quantity in PickerView
  func didUpdatePickerView(with value: Int) {
    userDidChangePickerView(with: value)
  }
  
  // User changed the product quantity in PickerView
  func userDidChangePickerView(with value: Int ) {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      cell.newPickerValue = value
    }
  }
  
  // Check if the product quantity in the Shopping Cart has changed
  func checkProductQuantityUpdate(for cell: CartProductCell, on index: Int) {
    
    let newQuantityValue = cell.newPickerValue
    if
      newQuantityValue > 0,
      cell.itemCountInShoppingCart != newQuantityValue
    {
      // Update product count in the cell
      cell.changeQuantityButton.text = "\(newQuantityValue)"
      cell.itemCountInShoppingCart = newQuantityValue
      cell.newPickerValue = 0
      
      // Update the product count in CoreData
      updateProductInCartCount(for: index, with: newQuantityValue)
    }
  }
  
}

