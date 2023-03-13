//
//  ProductCatalogCellDelegate.swift
//
//
//  Created by Cristina Dobson
//


// ProductCatalogCell Delegate
protocol ProductCatalogCellDelegate: AnyObject {
  
  func didTapAddToCartButton(
    fromProductCatalogCell cell: ProductCatalogCell)
  
}
