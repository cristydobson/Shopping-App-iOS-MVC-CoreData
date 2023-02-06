/*
 ProductPageViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 Display the product the user tapped on
 in ProductCatalogViewController
 */

import UIKit

protocol ProductPageViewControllerDelegate: AnyObject {
  func didTapAddToCartButtonFromProductPage(for product: Product)
}

class ProductPageViewController: UIViewController {

  //MARK: - Properties ******
  
  //Delegate
  weak var productPageViewControllerDelegate: ProductPageViewControllerDelegate?
  
  //Blur View
  @IBOutlet weak var blurView: UIView!
  
  //Product Object
  var productObject: Product?
  
  //Product Image
  @IBOutlet weak var productImageView: UIImageView!
  
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
  
  
  //MARK: - View Controller Setup ******
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = NSLocalizedString("Product",
                              comment: "Title from ProductPageViewController")
    
    //ScrollView - Container View
    containerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                    bottom: 120, right: 0)

    //Setup UI Style
    setupThumbnailStyle()
    setupAddToCartButton(isOn: true)
    
    //Setup Product Info
    loadImage()
    setupProductInfoLabels()
    
  }
  
  //MARK: - Setup UI Style ******
  func setupThumbnailStyle() {
    
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
  }
  
  //Setup the Add To Cart button style and text
  func setupAddToCartButton(isOn: Bool) {
    
    //Button's default text
    let addToCartButtonText = NSLocalizedString("Add to Shopping Cart",
                                                comment: "Add to Shopping Cart Button label text")
    attributedCartButtonText = addToCartButtonText.toStyledString(with: 16, and: .semibold)
    
    //Check if the button has a Checkmark animating on top of it
    let buttonText = isOn ? attributedCartButtonText : NSAttributedString(string: "",
                                                                          attributes: nil)
    
    //Set up the button's text
    addToCartButton.setAttributedTitle(
      buttonText,
      for: .normal
    )
    
    //Set up the button's style
    addToCartButton.addCornerRadius(25)
    
    addToCartButton.isEnabled = isOn
  }
  
  //MARK: - Setup Product Info ******
  
  //Load the image of the product from a URL
  func loadImage() {
    
    if
      let product = productObject,
      let imageURL = canCreateImageUrl(from: product)
    {
      
      //Attempt to load image
      let _ = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          //The UI must be accessed through the main thread
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
    if let productObj = productObject {
      
      //Add the name of the product
      productNameLabel.attributedText = getAttributedName(from: productObj,
                                                          withSize: 18)
      
      //Add the description of the product
      productDescriptionLabel.attributedText = getAttributedDescription(from: productObj,
                                                                        withSize: 18)
      
      //Add the price of the product
      productPriceLabel.attributedText = getAttributedPrice(from: productObj,
                                                            withSize: 34)
    }
  }
  
  //MARK: - Button Actions ******
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    
    /*
     Update the products in the Shopping Cart array
     in TabBarController
     */
    productPageViewControllerDelegate?.didTapAddToCartButtonFromProductPage(for: productObject!)
    
    /*
     Show a blurred background view while the Checkmark animation
     plays on the 'Add To Cart' button
     */
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    setupCheckmarkAnimation()
  }
  
}

//MARK: Checkmark Animation ******
extension ProductPageViewController {
   
  /*
   Animate a checkmark on the 'Add To Cart' button
   as feedback for the user
  */
  
  //Setup the Checkmark animation
  func setupCheckmarkAnimation() {
    checkmark = CheckmarkView()
    let checkmarkHeight = addToCartButton.frame.height-4
    let checkMarkRect = CGRect(x: 0, y: 0,
                               width: checkmarkHeight,
                               height: checkmarkHeight)
    
    checkmark.setupAnimation(
      frame: checkMarkRect,
      animatedLayerColor: .white,
      strokeWidth: 4,
      animated: true
    )
    
    //Add the checkmark to its container view
    checkmarkBGView.addSubview(self.checkmark)
    
    setupCheckmarkDependentUI()
    animateCheckmark()
  }
  
  //Setup the checkmark's dependent UI
  func setupCheckmarkDependentUI() {
    
    //Remove the text from the 'Add To Cart' button
    setupAddToCartButton(isOn: false)
  }
  
  //Start animating the Checkmark
  func animateCheckmark() {
    
    checkmark.animate(duration: 0.2) { finished in
      
      if finished {
        
        //The UI must be accessed through the main thread
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          
          //Remove the checkmark after it's done animating
          self.checkmark.removeFromSuperview()
          self.checkmark = nil
          
          //Return the Add To Cart button back to normal
          self.setupAddToCartButton(isOn: true)
          
          //Remove the blurred background view
          self.blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
        }
      }
    }
    
  }
  
}
