/*
 ProductCatalogCell.swift
 
 
 Created by Cristina Dobson
 
 This is the cell from ProductCatalogViewController's collectionView
 */


import UIKit


class ProductCatalogCell: UICollectionViewCell {

  
  // MARK: - Properties
  
  // Delegate
  weak var productCatalogCellDelegate: ProductCatalogCellDelegate?
  
  // View Container
  @IBOutlet weak var containerView: UIView!
  
  // Image properties
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  // Product Information
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  // Add to Cart Button
  @IBOutlet weak var addToCartButton: UIButton!
  
  
  // MARK: - awakeFromNib
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Add drop shadow to the cell
    addDropShadowToView()
    
    // UI Style
    setupThumbnail()
  }
  
  
  // MARK: - prepareForReuse
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    // Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
  
  
  // MARK: - Button Actions
  
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    
    // Animate the cell's Shopping Cart button being tapped
    ButtonAnimationHelper.animateShoppingCartRoundButton(sender)
    
    // Tell the cell's delegate about the button tap
    productCatalogCellDelegate?
      .didTapAddToCartButton(fromProductCatalogCell: self)
  }
  
}


// MARK: - UI Style
extension ProductCatalogCell {
  
  // Add drop shadow to the cell's view
  func addDropShadowToView() {
    backgroundColor = .clear
    addDropShadow(
      opacity: 0.23,
      radius: 4,
      offset: CGSize.zero,
      lightColor: .darkGray,
      darkColor: .white
    )
  }
  
  func setupThumbnail() {
    productImageView.addCornerRadius(5)
  }
  
}

