//
//  ProductCatalogCellDelegate.swift
//  ShoppableApp
//
//  Created on 2/10/23.
//


// ProductCatalogCell Delegate
protocol ProductCatalogCellDelegate: AnyObject {
  
  func didTapAddToCartButton(
    fromProductCatalogCell cell: ProductCatalogCell
  )
  
}
