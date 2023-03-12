//
//  ProductPageViewControllerDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductPageViewController Delegate
protocol ProductPageViewControllerDelegate: AnyObject {
  
  func didTapAddToCartButtonFromProductPage(
    for product: Product)
  
}

