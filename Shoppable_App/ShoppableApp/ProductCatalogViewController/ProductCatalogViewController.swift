/*
 ProductCatalogViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 Display the product list of a single type in a CollectionView
 */

import UIKit
import Foundation

protocol ProductCatalogViewControllerDelegate: AnyObject {
  func didTapAddToCartButtonFromProductCatalogController(for product: Product)
}

class ProductCatalogViewController: UIViewController {

  //MARK: - Properties ******
  
  //Delegate
  weak var productCatalogViewControllerDelegate: ProductCatalogViewControllerDelegate?
  
  //ProductPageViewController
  let productPageViewControllerSegue = "ProductPageViewControllerSegue"
  var userTappedProductObj: Product?
  
  //Observer Names
  var updateShoppingCartObserverName = "updateShoppingCartObserver"
  
  //Title
  var collectionName = ""
  var backButtonTitle = ""
  
  //Product Catalog
  var productList: [Product] = []
  
  //Products Collection View
  @IBOutlet weak var productCatalogCollectionView: UICollectionView!
  var productCellID = "ProductCatalogCell"
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  
  //MARK: - View Controller Life Cycle ******
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = collectionName
    navigationController?.navigationBar.topItem?.backButtonTitle = backButtonTitle

    //Setup the Product Catalog Collection View
    setupCollectionView(productCellID, for: productCatalogCollectionView, in: self)

  }
  
  //MARK: - ViewWillTransition ******
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    /*
     Reload the Products CollectionView to update
     its layout
     */
    productCatalogCollectionView.reloadData()
  }
  
  //MARK: - Navigation ******
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //Pass data for a product to ProductPageViewController
    if segue.identifier == productPageViewControllerSegue {
      let viewController = segue.destination as! ProductPageViewController
      viewController.productObject = userTappedProductObj
      viewController.imageLoader = imageLoader
      viewController.productPageViewControllerDelegate = self
    }
  }
  
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource ******
extension ProductCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  //1 section
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  //All products in the array in 1 section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productList.count
  }
  
  //Load the Product Cell
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellID, for: indexPath) as! ProductCatalogCell
    
    //Become the cell's delegate
    cell.productCatalogCellDelegate = self
    
    //Product to load in the current cell
    let currentProduct = productList[indexPath.row]
    
    //Add the name of the product
    cell.productNameLabel.attributedText = getAttributedName(from: currentProduct,
                                                             withSize: 16)
    
    //Add the description of the product
    cell.productDescriptionLabel.attributedText = getAttributedDescription(from: currentProduct,
                                                                           withSize: 16)
    
    //Add the price of the product
    cell.productPriceLabel.attributedText = getAttributedPrice(from: currentProduct,
                                                               withSize: 24)
    
    //Load the image of the product from a URL
    if let imageURL = canCreateImageUrl(from: currentProduct) {
      
      //Attempt to load image
      let token = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          //The UI must be accessed through the main thread
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
  
  //The cell was tapped 
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    /*
     Find the product the user tapped on and
     pass it to ProductPageViewController
     */
    userTappedProductObj = productList[indexPath.row]
    
    //Go to ProductPageViewController
    performSegue(withIdentifier: productPageViewControllerSegue, sender: self)
  }
  
  //Animate the cell being tapped
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    let cell = collectionView.cellForItem(at: indexPath)
    highlightCellOnTap(for: cell!)
    return true
  }
  
}

//MARK: - UICollectionViewDelegateFlowLayout ******
extension ProductCatalogViewController: UICollectionViewDelegateFlowLayout {
  
  //Set the cell's size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    //Change cell's size based on device orientation
    //LANDSCAPE
    if UIDevice.current.orientation.isLandscape {
      let landscapeWidth = view.frame.width/2.3
      return CGSize(width: landscapeWidth, height: landscapeWidth*1.5)
    }
    
    //PORTRAIT
    let portraitWidth = (view.frame.width/2)-1
    return CGSize(width: portraitWidth, height: portraitWidth*1.8)
  }
  
  //Set the insets around the CollectionView
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  }
  
  //Set the vertical space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2.0
  }
  
  //Set the horizontal space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
}

//MARK: - ProductCatalogCellDelegate ******
extension ProductCatalogViewController: ProductCatalogCellDelegate {
  
  //Update the products in the Shopping Cart array
  func didTapAddToCartButton(fromProductCatalogCell cell: ProductCatalogCell) {
    
    if let index = productCatalogCollectionView.indexPath(for: cell)?.row {
      /*
       Update the products in the Shopping Cart array
       in TabBarController
       */
      let currentProduct = productList[index]
      productCatalogViewControllerDelegate?.didTapAddToCartButtonFromProductCatalogController(for: currentProduct)
      
      /*
       Let the CartViewController know that it should update
       its list of products
       */
      NotificationCenter.default.post(
        name: Notification.Name(updateShoppingCartObserverName),
        object: nil
      )
    }
  }
  
}

//MARK: - ProductPageViewControllerDelegate ******
extension ProductCatalogViewController: ProductPageViewControllerDelegate {
  
  //Update the products in the Shopping Cart array
  func didTapAddToCartButtonFromProductPage(for product: Product) {
    
    /*
     Update the products in the Shopping Cart array
     in TabBarController
     */
    productCatalogViewControllerDelegate?.didTapAddToCartButtonFromProductCatalogController(for: product)
    
    /*
     Let the CartViewController know that it should update
     its list of products
     */
    NotificationCenter.default.post(
      name: Notification.Name(updateShoppingCartObserverName),
      object: nil
    )
  }
}

