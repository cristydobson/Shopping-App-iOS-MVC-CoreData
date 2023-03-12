/*
 ProductPageViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 Display the product the user tapped on
 in ProductCatalogViewController
 */

import UIKit


class ProductPageViewController: UIViewController {

  
  // MARK: - Properties
  
  // Delegate
  weak var productPageViewControllerDelegate: ProductPageViewControllerDelegate?
  
  // Blur View
  @IBOutlet weak var blurView: UIView!
  
  // Product Object
  var productObject: Product?
  
  // Product Image
  @IBOutlet weak var productImageView: UIImageView!
  
  // ScrollView - Container View
  @IBOutlet weak var containerScrollView: UIScrollView!
  
  // Product Info
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  // Add to Cart Button
  @IBOutlet weak var addToCartButton: UIButton!
  var attributedCartButtonText: NSAttributedString?
  
  // Image Loader
  var imageLoader: ImageDownloader?
  
  // Checkmark Animation
  @IBOutlet weak var checkmarkBGView: UIView!
  var checkmark: CheckmarkView!
  
  
  // MARK: - View Controller's Life Cycle 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Navigation Bar
    setupNavigationBar()
    
    // ScrollView - Container View
    setupContainerScrollView()
    
    // Setup UI
    setAddToCartButtonText()
    setupAddToCartButton(isEnabled: true)

    // UI Style
    thumbnailStyle()
    addToCartButtonStyle()
    
    // Load Product Info
    loadImage()
    setupProductInfoLabels()
    
  }
  
  
  // MARK: - Button Actions
  
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    
    /*
     Update the products in the Shopping Cart array
     in TabBarController
     */
    productPageViewControllerDelegate?
      .didTapAddToCartButtonFromProductPage(for: productObject!)
    
    /*
     Show a blurred background view while the Checkmark animation
     plays on the 'Add To Cart' button
     */
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    setupCheckmarkAnimation()
  }
  
}


// MARK: - Setup UI

extension ProductPageViewController {
  
  func setupNavigationBar() {
    title = NSLocalizedString(
      "Product",
      comment: "Title from ProductPageViewController")
  }
  
  // Setup ContainerScrollView
  func setupContainerScrollView() {
    containerScrollView.contentInset = UIEdgeInsets(
      top: 0, left: 0, bottom: 120, right: 0)
  }
  
  // AddToCart button's default text
  func setAddToCartButtonText() {
    
    let addToCartButtonText = NSLocalizedString(
      "Add to Shopping Cart",
      comment: "Add to Shopping Cart Button label text")
    
    attributedCartButtonText = addToCartButtonText
      .toStyleString(with: 16, and: .semibold)
  }
  
  // Setup the Add To Cart button
  func setupAddToCartButton(isEnabled: Bool) {
    
    // Check if the button has a Checkmark animating on top of it
    let buttonText = isEnabled ?
      attributedCartButtonText :
      NSAttributedString(string: "", attributes: nil)
    
    // Set the button's text
    addToCartButton.setAttributedTitle(
      buttonText, for: .normal)
    
    addToCartButton.isEnabled = isEnabled
  }
  
}


// MARK: - UI Style

extension ProductPageViewController {
  
  func thumbnailStyle() {
    
    // Customize the edge of the ContainerView
    productImageView.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray)
    
    productImageView.addCornerRadius(5)
    
    // Add drop shadow to the product's imageView
    productImageView.addDropShadow(
      opacity: 0.23,
      radius: 6,
      offset: CGSize.zero,
      lightColor: .gray,
      darkColor: .white
    )
  }
  
  // Add To Cart button's style
  func addToCartButtonStyle() {
    addToCartButton.addCornerRadius(25)
  }
  
}


// MARK: - Load Product Info

extension ProductPageViewController {
  
  /*
   Load the image of the product from a URL
   */
  func loadImage() {
    
    if
      let product = productObject,
      let imageURL = ProductInfoHelper.canCreateImageUrl(from: product)
    {
      
      // Attempt to load image
      let _ = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          // The UI must be accessed through the main thread
          DispatchQueue.main.async {
            self.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      // --> End of loading image closure
    }
  }
  
  func setupProductInfoLabels() {
    if let productObj = productObject {
      
      // Add the name of the product
      productNameLabel.attributedText = ProductAttributedStringHelper
        .getAttributedName(from: productObj, withSize: 18)
      
      // Add the description of the product
      productDescriptionLabel.attributedText = ProductAttributedStringHelper
        .getAttributedDescription(from: productObj, withSize: 18)
      
      // Add the price of the product
      productPriceLabel.attributedText = ProductAttributedStringHelper
        .getAttributedPrice(from: productObj, withSize: 34)
    }
  }
  
}
