/*
 ProductOverviewViewController.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 This ViewController shows the product collections by type
 */

import UIKit

//Describes a product object's type
typealias ProductDictionary = [String:AnyObject]

//Delegate -> TabBarController
protocol ProductOverviewViewControllerDelegate: AnyObject {
  func updateCartControllerFromProductCatalogController(with product: ProductDictionary)
}

class ProductOverviewViewController: UIViewController {

  //MARK: - Properties
  
  //Delegate
  weak var productOverviewViewControllerDelegate: ProductOverviewViewControllerDelegate?
  
  //Segue Identifiers
  let productCatalogSegue = "ProductCatalogViewControllerSegue"
  
  //ShoppingCart
  var itemsInShoppingCartIDs: [ProductDictionary] = []
  
  //Collection View
  @IBOutlet weak var productCollectionsList: UICollectionView!
  let productCollectionCellID = "ProductCollectionCell"
  
  //Products Data
  var productCollections: [ProductDictionary] = []
  var userTappedProductCollection: [ProductDictionary] = []
  var userTappedProductCollectionName = ""
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  
  //MARK: - View Controller' Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //NavigationBar
    title = NSLocalizedString("Collections", comment: "ProductOverviewViewController title")
    
    //Image Loader
    imageLoader = ImageDownloader()

    //Product Collections CollectionView setup
    productCollectionsList.delegate = self
    productCollectionsList.dataSource = self
    let cellNib = UINib(nibName: productCollectionCellID, bundle: nil)
    productCollectionsList.register(
      cellNib,
      forCellWithReuseIdentifier: productCollectionCellID
    )
  }
  
  //MARK: - View transition
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
   
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //Pass data to ProductCatalogViewController
    if segue.identifier == productCatalogSegue {
      let viewController = segue.destination as! ProductCatalogViewController
      viewController.productList = userTappedProductCollection
      viewController.collectionName = userTappedProductCollectionName
      viewController.itemsInShoppingCartIDs = itemsInShoppingCartIDs
      viewController.productCatalogViewControllerDelegate = self
    }
  }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productCollections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCollectionCellID, for: indexPath) as! ProductCollectionCell
    
    //Add the name of the product type
    let collectionType = CollectionType.allCases[indexPath.row]
    let collectionName = collectionType.productTypeTitle
    cell.collectionNameLabel.text = NSLocalizedString(collectionName,
                                                      comment: "Collection type")
    
    //Add the image of the product type
    let currentCollection = productCollections[indexPath.row]
    if let collectionProducts = currentCollection[ProductDataKeys.products.rawValue] as? [ProductDictionary],
       let firstProduct = collectionProducts.first,
       let productImageUrlString = firstProduct[ProductDataKeys.imageUrl.rawValue] as? String,
       let productImageURL = URL(string: productImageUrlString) {
      
      let token = imageLoader?.loadImage(productImageURL) { result in
        do {
          let image = try result.get()
          DispatchQueue.main.async {
            cell.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      
      cell.onReuse = {
        if let token = token {
          self.imageLoader?.cancelImageDownload(token)
        }
      }
    }
        
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    /*
     Get the list of products to pass to ProductCatalogViewController
     based on the type the user tapped on
     */
    let currentProductTypeCase = CollectionType.allCases[indexPath.row]
    let currentProductType = currentProductTypeCase.rawValue
    for productCollection in productCollections {
      if
        let productType = productCollection[ProductDataKeys.type.rawValue] as? String,
         productType == currentProductType,
        let productList: [ProductDictionary] = productCollection[ProductDataKeys.products.rawValue] as? [ProductDictionary]
      {
        userTappedProductCollection = productList
        userTappedProductCollectionName = currentProductTypeCase.productTypeTitle
        break
      }
    }
    performSegue(withIdentifier: productCatalogSegue, sender: self)
  }
  
  //Animate the cell being tapped
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    
    let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionCell
    UIView.animate(
      withDuration: 0.2,
      animations: {
        cell.alpha = 0.5
    }) { (_) in
      UIView.animate(withDuration: 0.2) {
        cell.alpha = 1.0
      }
    }
    return true
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProductOverviewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //Change cell's size based on device orientation
    if UIDevice.current.orientation.isLandscape {
      let landscapeWidth = (view.frame.width/2.3)
      return CGSize(width: landscapeWidth, height: landscapeWidth*0.7)
    }
    let portraitWidth = view.frame.width - 40
    return CGSize(width: portraitWidth, height: portraitWidth * 0.8)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}

//MARK: - ProductCatalogViewControllerDelegate
extension ProductOverviewViewController: ProductCatalogViewControllerDelegate {
  //Update the products in the Shopping Cart array
  func didTapAddToCartButtonFromProductCatalogController(for product: ProductDictionary) {
    productOverviewViewControllerDelegate?.updateCartControllerFromProductCatalogController(with: product)
  }
}




