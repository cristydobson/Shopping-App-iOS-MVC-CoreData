/*
 ProductOverviewViewController.swift
 
 Created by Cristina Dobson
 
 This ViewController shows the product collections by type
 */

import UIKit


class ProductOverviewViewController: UIViewController {

  
  // MARK: - Properties
  
  var screenTitle = ""
  
  // Delegate
  weak var productOverviewViewControllerDelegate: ProductOverviewViewControllerDelegate?
  
  // Segue Identifiers
  let productCatalogSegue = "ProductCatalogViewControllerSegue"
  
  // Collection View
  @IBOutlet weak var productCollectionsList: UICollectionView!
  let productCollectionCellID = "ProductCollectionCell"
  
  // Products Data
  var productCollections: [ProductCollection] = []
  var userTappedProductCollection: [Product] = []
  var userTappedProductCollectionName = ""
  
  // Image Loader
  var imageLoader: ImageDownloader?
  
  
  // MARK: - View Controller's Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // NavigationBar
    setupNavigationBar()

    // Product Collections CollectionView setup
    ObjectCollectionHelper.setupCollectionView(
      productCollectionCellID,
      for: productCollectionsList, in: self)
  }
  
  
  // MARK: - View transition
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    productCollectionsList.reloadData()
    
    /*
     Allow the large title in the navigationBar to go back
     to normal size on the view's transition to portrait orientation
    */
    coordinator.animate { (_) in
      self.navigationController?.navigationBar.sizeToFit()
    }
  }
   
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // Pass data to ProductCatalogViewController
    if segue.identifier == productCatalogSegue {
      
      let viewController = segue.destination as! ProductCatalogViewController
      viewController.productList = userTappedProductCollection
      viewController.collectionName = userTappedProductCollectionName
      viewController.imageLoader = imageLoader
      viewController.backButtonTitle = screenTitle
      viewController.productCatalogViewControllerDelegate = self
    }
  }
  
}


// MARK: - Setup UI

extension ProductOverviewViewController {
  
  func setupNavigationBar() {
    screenTitle = NSLocalizedString(
      "Collections",
      comment: "ProductOverviewViewController title")
    title = screenTitle
  }
  
}


