//
//  ProductCatalogVcCollectionLayout.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// UICollectionViewDelegateFlowLayout

extension ProductCatalogViewController: UICollectionViewDelegateFlowLayout {
  
  
  // MARK: - Set the cell's size
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    /*
     Change the cell's size based on device orientation
     */
    
    // LANDSCAPE
    if UIDevice.current.orientation.isLandscape {
      let landscapeWidth = view.frame.width/2.3
      return CGSize(width: landscapeWidth, height: landscapeWidth*1.5)
    }
    
    // PORTRAIT
    let portraitWidth = (view.frame.width/2)-1
    return CGSize(width: portraitWidth, height: portraitWidth*1.8)
  }
  
  
  // MARK: - Collection View Insets
  
  // Set the insets around the CollectionView
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  }
  
  
  // MARK: - Cell Spacing
  
  // Set the vertical space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2.0
  }
  
  // Set the horizontal space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
}






