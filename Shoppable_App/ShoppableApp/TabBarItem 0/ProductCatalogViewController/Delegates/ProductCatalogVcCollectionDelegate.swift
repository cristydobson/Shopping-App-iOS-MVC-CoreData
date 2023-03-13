//
//  ProductCatalogVcCollectionDelegate.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// UICollectionViewDelegate, UICollectionViewDataSource

extension ProductCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  // MARK: - Section count
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  // MARK: - numberOfItemsInSection
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productList.count
  }
  
  
  // MARK: - cellForItemAt
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: productCellID,
      for: indexPath) as! ProductCatalogCell
    
    // Become the cell's delegate
    cell.productCatalogCellDelegate = self
    
    // Product to load in the current cell
    let currentProduct = productList[indexPath.row]
    
    // Add the name of the product
    cell.productNameLabel.attributedText = ProductAttributedStringHelper
      .getAttributedName(from: currentProduct.name, withSize: 16)
    
    // Add the description of the product
    cell.productDescriptionLabel.attributedText = ProductAttributedStringHelper
      .getAttributedDescription(from: currentProduct, withSize: 16)
    
    // Add the price of the product
    cell.productPriceLabel.attributedText = ProductAttributedStringHelper
      .getAttributedPrice(from: currentProduct, withSize: 24)
    
    /*
     Load the image of the product from a URL
     */
    if let imageURL = ProductInfoHelper.canCreateImageUrl(from: currentProduct.imageUrl) {
      
      // Attempt to load image
      let token = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          // The UI must be accessed through the main thread
          DispatchQueue.main.async {
            cell.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      
      /*
       When the cell is being reused, cancel loading the image.
       Use [unowned self] to avoid retention of self
       in the cell's onReuse() closure.
       */
      cell.onReuse = { [unowned self] in
        if let token = token {
          self.imageLoader?.cancelImageDownload(token)
        }
      }
    }
    
    return cell
  }
  
  
  // MARK: - Cell was tapped
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    /*
     Find the product the user tapped on and
     pass it to ProductPageViewController
     */
    userTappedProductObj = productList[indexPath.row]
    
    // Go to ProductPageViewController
    performSegue(withIdentifier: productPageViewControllerSegue, sender: self)
  }
  
  
  // MARK: - Animate cell being tapped
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    
    let cell = collectionView.cellForItem(at: indexPath)
    ObjectCollectionHelper.highlightCellOnTap(for: cell!)
    return true
  }
  
}










