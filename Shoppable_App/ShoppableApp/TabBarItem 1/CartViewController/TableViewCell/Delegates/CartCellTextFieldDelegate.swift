//
//  CartCellTextFieldDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


import UIKit


// UITextFieldDelegate
extension CartProductCell: UITextFieldDelegate {
  
  // MARK: - DidBeginEditing
  /*
   Tell the CartViewController that the user tapped on
   the changeQuantityButton textfield,
   so it displays the pivkerView
   */
  func textFieldDidBeginEditing(_ textField: UITextField) {
    cartProductCellDelegate?.didTapChangeQuantityButton(from: self)
  }
}
