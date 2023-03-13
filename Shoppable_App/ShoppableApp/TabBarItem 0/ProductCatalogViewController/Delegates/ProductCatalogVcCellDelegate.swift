//
//  ProductCatalogVcCellDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// ProductCatalogCellDelegate

extension ProductCatalogViewController: ProductCatalogCellDelegate {
  
  // Update the products in the Shopping Cart array
  func didTapAddToCartButton(fromProductCatalogCell cell: ProductCatalogCell) {
    
    if let index = productCatalogCollectionView.indexPath(for: cell)?.row {
      /*
       Update the products in the Shopping Cart array
       in TabBarController
       */
      let currentProduct = productList[index]
      productCatalogViewControllerDelegate?
        .didTapAddToCartButtonFromProductCatalogController(for: currentProduct)
      
      /*
       Let the CartViewController know that it should update
       its list of products
       */
      postToUpdateShoppingCartObserver()
    }
  }
  
}



















