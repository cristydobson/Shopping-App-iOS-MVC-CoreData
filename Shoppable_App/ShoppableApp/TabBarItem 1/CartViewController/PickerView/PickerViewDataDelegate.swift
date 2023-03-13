//
//  PickerViewDataDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// UIPickerViewDelegate, UIPickerViewDataSource 

extension QuantityPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  // MARK: - Column count
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  // MARK: - Rows per column
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return productCountMax
  }
  
  
  // MARK: - Add data
  /*
   Data for each row.
   A number in the range of 1...productCountMax
   */
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row+1)"
  }
  
  
  // MARK: - Update pickerView row selection
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    /*
     Update the value chosen by the user in the pickerView,
     to compare it with the old value when the pickerView is dismissed
     */
    quantityPickerViewDelegate?.didUpdatePickerView(with: row+1)
  }
  
}
