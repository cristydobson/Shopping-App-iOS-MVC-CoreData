//
//  ProductPageViewControllerDelegate.swift
//
//
//  Created by Cristina Dobson
//


// ProductPageViewController Delegate
protocol ProductPageViewControllerDelegate: AnyObject {
  
  func didTapAddToCartButtonFromProductPage(
    for product: Product)
  
}

