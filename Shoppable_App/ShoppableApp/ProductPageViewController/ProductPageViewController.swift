/*
 ProductPageViewController.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 Display the product the user tapped on
 in ProductCatalogViewController
 */

import UIKit

protocol ProductPageViewControllerDelegate: AnyObject {
  func didTapAddToCartButtonFromProductPage(for product: ProductDictionary)
}

class ProductPageViewController: UIViewController {

  //MARK: - Properties
  
  //Delegate
  weak var productPageViewControllerDelegate: ProductPageViewControllerDelegate?
  
  //Blur View
  @IBOutlet weak var blurView: UIView!
  
  //Product Information Class
  var productInfoClass: ProductInformation?
  
  //Product Dictionary
  var productDictionary: ProductDictionary?
  
  //Product Image
  @IBOutlet weak var productImageView: UIImageView!
  
  //ShoppingCart
  var itemInShoppingCartInfoDict: ProductDictionary = [:]
  
  //ScrollView - Container View
  @IBOutlet weak var containerScrollView: UIScrollView!
  
  //Product Info
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  //Add to Cart Button
  @IBOutlet weak var addToCartButton: UIButton!
  var attributedCartButtonText: NSAttributedString?
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  //Checkmark Animation
  @IBOutlet weak var checkmarkBGView: UIView!
  var checkmark: CheckmarkView!
  
  
  //MARK: - View Controller Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = NSLocalizedString("Product",
                              comment: "Title from ProductPageViewController")
    
    //ScrollView - Container View
    containerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                    bottom: 120, right: 0)
    
    //Product Information Class
    productInfoClass = ProductInformation()
   
    //Add the image of the product
    imageLoader = ImageDownloader()
    
    //Setup UI
    setupThumbnail()
    setupProductInfoLabels()
    setupAddToCartButton()
  }
  
  //MARK: - Button Actions
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    //Update the Shopping Cart through the delegate
    productPageViewControllerDelegate?.didTapAddToCartButtonFromProductPage(for: productDictionary!)
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    addCheckmarkAnimation()
  }
  
  //MARK: - Setup UI Methods
  func setupThumbnail() {
    //Customize the edge of the ContainerView
    productImageView.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray
    )
    productImageView.addCornerRadius(5)
    
    //Add drop shadow to the product's imageView
    productImageView.addDropShadow(
      opacity: 0.23,
      radius: 6,
      offset: CGSize.zero,
      lightColor: .gray,
      darkColor: .white
    )
    
    //Load the image of the product
    if
      let imageUrlString = productDictionary?[ProductDataKeys.imageUrl.rawValue] as? String,
      let imageURL = URL(string: imageUrlString) {
      
      let _ = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          DispatchQueue.main.async {
            self.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
    }
  }
  
  func setupProductInfoLabels() {
    if let productDict = productDictionary {
      
      //Add the name of the product
      let productName = productInfoClass?.getProductName(from: productDict).uppercased()
      let attributedName = productName?.toStyledString(with: 18, and: .bold)
      productNameLabel.attributedText = attributedName
      
      //Add the description of the product
      if let productInfo = productInfoClass?.getProductInfo(from: productDict) {
        let infoArray = productInfoClass?.getProductInfoKeys(from: productInfo)
        let productDescription = productInfoClass?.createDescriptionString(
          with: infoArray!,
          from: productInfo
        )
        let attributedDescription = productDescription?.toStyledString(with: 18, and: .regular)
        productDescriptionLabel.attributedText = attributedDescription
      }
      
      //Add the price of the product
      let priceCurrency = productInfoClass?.getProductPriceCurrency(from: productDict)
      let price = productInfoClass?.getProductPrice(from: productDict).toCurrencyFormat(in: priceCurrency!)
      let attributedPriceString = price!.toCurrencyAttributedString(with: 34)
      productPriceLabel.attributedText = attributedPriceString
    }
  }
  
  //Setup the Add To Cart button style and text
  func setupAddToCartButton() {
    let addToCartButtonText = NSLocalizedString("Add to Shopping Cart",
                                                comment: "Add to Shopping Cart Button label text")
    attributedCartButtonText = addToCartButtonText.toStyledString(with: 16, and: .semibold)
    addToCartButton.setAttributedTitle(
      attributedCartButtonText,
      for: .normal
    )
    addToCartButton.addCornerRadius(25)
  }
}

//MARK: Checkmark Animation
extension ProductPageViewController {
  
  /*
   Animate a checkmark on the Add To Cart button
   as feedback for the user
  */
  func addCheckmarkAnimation() {
    checkmark = CheckmarkView()
    let checkmarkHeight = addToCartButton.frame.height-4
    let checkMarkRect = CGRect(x: 0, y: 0,
                               width: checkmarkHeight,
                               height: checkmarkHeight)
    checkmark.setupAnimation(
      frame: checkMarkRect,
      initialLayerColor: .white,
      animatedLayerColor: .white,
      strokeWidth: 4,
      animated: true
    )
    checkmarkBGView.addSubview(self.checkmark)
    addToCartButton.setAttributedTitle(
      NSAttributedString(string: "", attributes: nil),
      for: .normal
    )
    
    checkmark.animate(duration: 0.2) { finished in
      if finished {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          //Remove the checkmark after it's done animating
          self.checkmark.removeFromSuperview()
          self.checkmark = nil
          //Return the Add To Cart button back to normal
          self.addToCartButton.setAttributedTitle(
            self.attributedCartButtonText,
            for: .normal
          )
          self.blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
        }
      }
    }
  }
}
