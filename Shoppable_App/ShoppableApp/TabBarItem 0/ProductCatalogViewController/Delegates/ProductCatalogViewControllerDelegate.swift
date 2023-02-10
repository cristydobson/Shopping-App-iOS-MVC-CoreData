//
//  ProductCatalogViewControllerDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductCatalogViewController Delegate
protocol ProductCatalogViewControllerDelegate: AnyObject {
  
  func didTapAddToCartButtonFromProductCatalogController(
    for product: Product
  )
  
}
