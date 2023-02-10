//
//  ProductOverviewViewControllerDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductOverviewViewController Delegate

protocol ProductOverviewViewControllerDelegate: AnyObject {
  
  func updateCartControllerFromProductCatalogController(
    with product: Product
  )
  
}





