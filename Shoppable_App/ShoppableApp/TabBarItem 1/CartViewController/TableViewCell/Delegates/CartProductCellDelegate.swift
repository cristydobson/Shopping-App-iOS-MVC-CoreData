//
//  CartProductCellDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// CartProductCell Delegate
protocol CartProductCellDelegate: AnyObject {
  
  func didRemoveItemFromShoppingCart(from cell: CartProductCell)
  
  func didTapChangeQuantityButton(from cell: CartProductCell)
  
}
