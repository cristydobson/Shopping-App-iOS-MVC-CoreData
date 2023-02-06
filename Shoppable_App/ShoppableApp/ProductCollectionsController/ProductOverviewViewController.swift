/*
 ProductOverviewViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 This ViewController shows the product collections by type
 */

import UIKit

//Describes a product object's type
typealias ProductDictionary = [String:AnyObject]

//Delegate -> TabBarController
protocol ProductOverviewViewControllerDelegate: AnyObject {
  func updateCartControllerFromProductCatalogController(with product: Product)
}

class ProductOverviewViewController: UIViewController {

  //MARK: - Properties ******
  
  var screenTitle = ""
  
  //Delegate
  weak var productOverviewViewControllerDelegate: ProductOverviewViewControllerDelegate?
  
  //Segue Identifiers
  let productCatalogSegue = "ProductCatalogViewControllerSegue"
  
  //Collection View
  @IBOutlet weak var productCollectionsList: UICollectionView!
  let productCollectionCellID = "ProductCollectionCell"
  
  //Products Data
  var productCollections: [ProductCollection] = []
  var userTappedProductCollection: [Product] = []
  var userTappedProductCollectionName = ""
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  
  //MARK: - View Controller' Life Cycle ******
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //NavigationBar
    title = screenTitle

    //Product Collections CollectionView setup
    setupCollectionView(productCollectionCellID, for: productCollectionsList, in: self)
  }
  
  //MARK: - View transition ******
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
   
  //MARK: - Navigation ******
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //Pass data to ProductCatalogViewController
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

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource ******
extension ProductOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  //1 section
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  //All product collections in the array in 1 section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productCollections.count
  }
  
  //Load the Product Collection Cell
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCollectionCellID, for: indexPath) as! ProductCollectionCell
    
    //Add the name of the product type
    cell.collectionNameLabel.text = getProductCollectionTypeLocalizedName(from: indexPath.row)
    
    //Load the image of the product type from a URL
    if
      let firstItem = productCollections[indexPath.row].products.first,
      let productImageURL = canCreateImageUrl(from: firstItem)
    {
      //Attempt to load image
      let token = imageLoader?.loadImage(productImageURL) { result in
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
     Get the list of products to pass to ProductCatalogViewController
     based on the product type the user tapped on
     */
    let index = indexPath.row
    let productList = productCollections[index].products
    userTappedProductCollection = productList
    userTappedProductCollectionName = getProductCollectionTypeLocalizedName(from: index)
    
    //Go to ProductCatalogViewController
    performSegue(withIdentifier: productCatalogSegue, sender: self)
  }
  
  //Animate the cell being tapped
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    
    let cell = collectionView.cellForItem(at: indexPath)
    highlightCellOnTap(for: cell!)
    return true
  }
  
}

//MARK: - UICollectionViewDelegateFlowLayout ******
extension ProductOverviewViewController: UICollectionViewDelegateFlowLayout {
  
  //Set the cell's size
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    //Change cell's size based on device orientation
    //LANDSCAPE
    if UIDevice.current.orientation.isLandscape {
      let landscapeWidth = (view.frame.width/2.4)
      return CGSize(width: landscapeWidth, height: landscapeWidth*0.7)
    }
    
    //PORTRAIT
    let portraitWidth = view.frame.width - 40
    return CGSize(width: portraitWidth, height: portraitWidth * 0.8)
  }
  
  //Set the insets around the CollectionView
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  //Set the vertical space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  
  //Set the horizontal space in between cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
}

//MARK: - ProductCatalogViewControllerDelegate ******
extension ProductOverviewViewController: ProductCatalogViewControllerDelegate {
  
  /*
   Update the products in the Shopping Cart array
   in TabBarController
   */
  func didTapAddToCartButtonFromProductCatalogController(for product: Product) {
    productOverviewViewControllerDelegate?.updateCartControllerFromProductCatalogController(with: product)
  }
  
}




