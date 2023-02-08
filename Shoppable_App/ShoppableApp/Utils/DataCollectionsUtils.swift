//
//  DataCollectionUtils.swift
//  ShoppableApp
//
//  Created on 2/2/23.
//

import Foundation
import UIKit


// CollectionView delegates and cell setup
func setupCollectionView(_ cellID: String, for collectionView: UICollectionView, in viewController: UIViewController) {
  
  collectionView.delegate = viewController as? UICollectionViewDelegate
  collectionView.dataSource = viewController as? any UICollectionViewDataSource
  let cellNib = UINib(nibName: cellID, bundle: nil)
  collectionView.register(
    cellNib,
    forCellWithReuseIdentifier: cellID
  )
}


// TableView cell setup
func setupTableView(_ cellID: String, for tableView: UITableView, in viewController: UIViewController) {

  let cellNib = UINib(nibName: cellID, bundle: nil)
  tableView.register(
    cellNib,
    forCellReuseIdentifier: cellID
  )
}


// Highlight Any Cell on tap
func highlightCellOnTap(for cell: UIView) {
  
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


