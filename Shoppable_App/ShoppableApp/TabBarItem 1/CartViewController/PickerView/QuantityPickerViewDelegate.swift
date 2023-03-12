//
//  QuantityPickerViewDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// QuantityPickerView Delegate

protocol QuantityPickerViewDelegate: AnyObject {
  
  // ToolBar button actions
  func didTapDoneButtonOnToolBar()
  func didTapCancelButtonOnToolBar()
  
  // Picker update
  func didUpdatePickerView(with value: Int)
  
}
