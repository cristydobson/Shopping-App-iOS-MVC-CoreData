//
//  ProductCatalogViewControllerDelegate.swift
//
//
//  Created by Cristina Dobson
//


// ProductCatalogViewController Delegate
protocol ProductCatalogViewControllerDelegate: AnyObject {
  
  func didTapAddToCartButtonFromProductCatalogController(
    for product: Product)
  
}
