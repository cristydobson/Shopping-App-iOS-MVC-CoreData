//
//  QuantityPickerView.swift
//  ShoppableApp
//
//  Created on 2/5/23.
//


import UIKit


class QuantityPickerView: UIPickerView {

  
  // MARK: - Properties
  
  let productCountMax = 1000
  
  // Delegate
  weak var quantityPickerViewDelegate: QuantityPickerViewDelegate?
  
  // ToolBar
  var pickerToolBar: UIToolbar!
  
  
  //MARK: - Setup Method
  func setupPickerView() {
    setupChangeQuantityPickerViewToolBar()
    dataSource = self
    delegate = self
  }
  
  
  // MARK: - Setup toolbar
  
  // Setup the Quantity PickerView's ToolBar
  func setupChangeQuantityPickerViewToolBar() {
    createPickerViewToolBar()
    addQuantityPickerViewButtons()
  }
  
  // Create the PickerView's ToolBar
  func createPickerViewToolBar() {
    pickerToolBar = UIToolbar(
      frame: CGRect(x: 0, y: 0,
                    width: frame.width, height: 24))
    
    pickerToolBar?.barStyle = UIBarStyle.default
    pickerToolBar?.isTranslucent = true
    pickerToolBar.backgroundColor = .systemBackground
    pickerToolBar?.tintColor = .label
    pickerToolBar?.sizeToFit()
    pickerToolBar?.isUserInteractionEnabled = true
  }
  
  
  // MARK: - Add ToolBar buttons
  
  // Add buttons to the Quantity PickerView's ToolBar
  func addQuantityPickerViewButtons() {
    
    // The user is done changing a product's quantity
    let doneButton = createToolBarButtonItem(
      name: "Done",
      buttonStyle: .done,
      buttonAction: #selector(tappedDoneButtonOnPicker))
    
    // Empty space in between the buttons
    let spaceButton = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
      target: nil,
      action: nil)
    
    // The user has canceled changing the product's quantity
    let cancelButton = createToolBarButtonItem(
      name: "Cancel",
      buttonStyle: .plain,
      buttonAction: #selector(didCancelPickerView))
    
    // Add the buttons to the ToolBar
    pickerToolBar?.setItems(
      [cancelButton, spaceButton, doneButton],
      animated: false)
  }
  
  // Create a button for the PickerView's toolBar
  func createToolBarButtonItem(name: String, buttonStyle: UIBarButtonItem.Style, buttonAction: Selector?) -> UIBarButtonItem {
    
    return UIBarButtonItem(
      title: NSLocalizedString(name, comment: "Picker ToolBar button"),
      style: buttonStyle,
      target: self,
      action: buttonAction)
  }
  
  
  // MARK: - ToolBar buttons actions
  
  /*
   Action triggered when the pickerView's
   toolBar button "Done" is tapped
   */
  @objc func tappedDoneButtonOnPicker() {
    quantityPickerViewDelegate?.didTapDoneButtonOnToolBar()
  }
  
  /*
   Action triggered when the pickerView's
   toolBar button "Cancel" is tapped
   */
  @objc func didCancelPickerView() {
    quantityPickerViewDelegate?.didTapCancelButtonOnToolBar()
  }
  
}


