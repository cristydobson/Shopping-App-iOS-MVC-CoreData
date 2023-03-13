//
//  ObjectCollectionHelper.swift
//
//
//  Created by Cristina Dobson
//


import Foundation
import UIKit


struct ObjectCollectionHelper {
  
  
  // MARK: - CollectionView setup
  
  // CollectionView delegates and cell setup
  static func setupCollectionView(_ cellID: String, for collectionView: UICollectionView, in viewController: UIViewController) {
    
    collectionView.delegate = viewController as? UICollectionViewDelegate
    collectionView.dataSource = viewController as? any UICollectionViewDataSource
    
    let cellNib = UINib(nibName: cellID, bundle: nil)
    collectionView.register(
      cellNib, forCellWithReuseIdentifier: cellID)
  }
  
  
  // MARK: - TableView cell setup
  
  static func setupTableView(_ cellID: String, for tableView: UITableView, in viewController: UIViewController) {
    
    let cellNib = UINib(nibName: cellID, bundle: nil)
    tableView.register(
      cellNib, forCellReuseIdentifier: cellID)
  }
  
  
  // MARK: - Highlight a collection cell on tap
  
  // Highlight Any Cell on tap
  static func highlightCellOnTap(for cell: UIView) {
    
    UIView.animate(
      withDuration: 0.2,
      animations: {
        cell.alpha = 0.5
      }) { (_) in
        UIView.animate(withDuration: 0.2) {
          cell.alpha = 1.0
        }
      }
  }
  
}










