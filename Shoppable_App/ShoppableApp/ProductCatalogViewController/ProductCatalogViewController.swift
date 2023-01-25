/*
 ProductCatalogViewController.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 Display the product list of a single type in a CollectionView
 */

import UIKit
import Foundation

protocol ProductCatalogViewControllerDelegate: AnyObject {
  func didTapAddToCartButtonFromProductCatalogController(for product: ProductDictionary)
}

class ProductCatalogViewController: UIViewController {

  //MARK: - Properties
  
  //Delegate
  weak var productCatalogViewControllerDelegate: ProductCatalogViewControllerDelegate?
  
  //Product Information Class
  var productInfoClass: ProductInformation?
  
  //ProductPageViewController
  let productPageViewControllerSegue = "ProductPageViewControllerSegue"
  var userTappedProductDict: ProductDictionary?
  
  //Observer Names
  var updateShoppingCartObserverName = "updateShoppingCartObserver"
  
  //Title
  var collectionName = ""
  
  //Product Catalog
  var productList: [ProductDictionary] = []
  
  //ShoppingCart
  var itemsInShoppingCartIDs: [ProductDictionary] = []
  var itemInShoppingCartInfoDict: ProductDictionary = [:]
  var tappedProductIsInShoppingCart = false
  
  //Products Collection View
  @IBOutlet weak var productCatalogCollectionView: UICollectionView!
  var productCellID = "ProductCatalogCell"
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = NSLocalizedString("\(collectionName)", comment: "ProductCatalogViewController title")
    navigationController?.navigationBar.topItem?.backButtonTitle = NSLocalizedString("Collections", comment: "Nav Bar Back button title to ProductOverviewViewController")
    
    //Product Information Class
    productInfoClass = ProductInformation()
    
    //Image Loader
    imageLoader = ImageDownloader()
    
    //Setup the Product Catalog Collection View
    productCatalogCollectionView.delegate = self
    productCatalogCollectionView.dataSource = self
    let cellNib = UINib(nibName: productCellID, bundle: nil)
    productCatalogCollectionView.register(
      cellNib,
      forCellWithReuseIdentifier: productCellID
    )
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    productCatalogCollectionView.reloadData()
  }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //Pass data for a product to ProductPageViewController
    if segue.identifier == productPageViewControllerSegue {
      let viewController = segue.destination as! ProductPageViewController
      viewController.productDictionary = userTappedProductDict
      viewController.productPageViewControllerDelegate = self
    }
  }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellID, for: indexPath) as! ProductCatalogCell
    cell.productCatalogCellDelegate = self
    
    let currentProduct = productList[indexPath.row]
    
    //Add the name of the product
    let name = productInfoClass?.getProductName(from: currentProduct).uppercased()
    let attributedName = name?.toStyledString(with: 16, and: .bold)
    cell.productNameLabel.attributedText = attributedName
    
    //Add the description of the product
    if let productInfo = productInfoClass?.getProductInfo(from: currentProduct) {
      let infoArray = productInfoClass?.getProductInfoKeys(from: productInfo)
      let productDescription = productInfoClass?.createDescriptionString(with: infoArray!, from: productInfo)
      let attributedDescription = productDescription?.toStyledString(with: 16, and: .regular)
      cell.productDescriptionLabel.attributedText = attributedDescription
    }
    
    //Add the price of the product
    let priceCurrency = productInfoClass?.getProductPriceCurrency(from: currentProduct)
    let price: String = (productInfoClass?.getProductPrice(from: currentProduct).toCurrencyFormat(in: priceCurrency!))!
    let attributedPriceString = price.toCurrencyAttributedString(with: 24)
    cell.productPriceLabel.attributedText = attributedPriceString
    
    //Load the image of the product
    if
      let imageUrlString = currentProduct[ProductDataKeys.imageUrl.rawValue] as? String,
      let imageURL = URL(string: imageUrlString) {
      
      let token = imageLoader?.loadImage(imageURL) { result in
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
    
    //Get the product the user tapped on and pass it to ProductPageViewController
    let productDict = productList[indexPath.row]
    userTappedProductDict = productDict
    performSegue(withIdentifier: productPageViewControllerSegue, sender: self)
  }
  
  //Animate the cell being tapped
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    
    let cell = collectionView.cellForItem(at: indexPath) as! ProductCatalogCell
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
extension ProductCatalogViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //Change cell's size based on device orientation
    if UIDevice.current.orientation.isLandscape {
      let landscapeWidth = view.frame.width/2.3
      return CGSize(width: landscapeWidth, height: landscapeWidth*1.5)
    }
    let portraitWidth = (view.frame.width/2)-1
    return CGSize(width: portraitWidth, height: portraitWidth*1.8)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
}

//MARK: - ProductCatalogCellDelegate
extension ProductCatalogViewController: ProductCatalogCellDelegate {
  
  //Update the products in the Shopping Cart array
  func didTapAddToCartButton(fromProductCatalogCell cell: ProductCatalogCell) {
    let indexPath = productCatalogCollectionView.indexPath(for: cell)
    if let index = indexPath?.row as? Int {
      let currentProduct = productList[index]
      productCatalogViewControllerDelegate?.didTapAddToCartButtonFromProductCatalogController(for: currentProduct)
      
      //Let the CartViewController know that it should update its list of products
      NotificationCenter.default.post(
        name: Notification.Name(updateShoppingCartObserverName),
        object: nil
      )
    }
  }
}

//MARK: - ProductPageViewControllerDelegate
extension ProductCatalogViewController: ProductPageViewControllerDelegate {
  
  //Update the products in the Shopping Cart array
  func didTapAddToCartButtonFromProductPage(for product: ProductDictionary) {
    productCatalogViewControllerDelegate?.didTapAddToCartButtonFromProductCatalogController(for: product)
    
    //Let the CartViewController know that it should update its list of products
    NotificationCenter.default.post(
      name: Notification.Name(updateShoppingCartObserverName),
      object: nil
    )
  }
}

