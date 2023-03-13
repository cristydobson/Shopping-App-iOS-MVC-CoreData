//
//  CartProductCellDelegate.swift
//  
//
//  Created by Cristina Dobson
//


// CartProductCell Delegate

protocol CartProductCellDelegate: AnyObject {
  
  func didRemoveItemFromShoppingCart(from cell: CartProductCell)
  
  func didTapChangeQuantityButton(from cell: CartProductCell)
  
}
