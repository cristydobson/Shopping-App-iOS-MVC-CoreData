//
//  ProductCatalogVcPageDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// ProductPageViewControllerDelegate

extension ProductCatalogViewController: ProductPageViewControllerDelegate {
  
  // Update the products in the Shopping Cart array
  func didTapAddToCartButtonFromProductPage(for product: Product) {
    
    /*
     Update the products in the Shopping Cart array
     in TabBarController
     */
    productCatalogViewControllerDelegate?
      .didTapAddToCartButtonFromProductCatalogController(for: product)
    
    /*
     Let the CartViewController know that it should update
     its list of products
     */
    postToUpdateShoppingCartObserver()
  }
}
