//
//  ProductOverviewVcCatalogDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductCatalogViewControllerDelegate

extension ProductOverviewViewController: ProductCatalogViewControllerDelegate {
  
  /*
   Update the products in the Shopping Cart array
   in TabBarController
   */
  func didTapAddToCartButtonFromProductCatalogController(for product: Product) {
    productOverviewViewControllerDelegate?.updateCartControllerFromProductCatalogController(with: product)
  }
  
}
