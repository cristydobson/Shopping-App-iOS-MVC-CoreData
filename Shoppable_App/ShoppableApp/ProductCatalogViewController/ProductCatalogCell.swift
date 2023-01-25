/*
 ProductCatalogCell.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 This is the cell from ProductCatalogViewController's collectionView
 */

import UIKit

protocol ProductCatalogCellDelegate: AnyObject {
  func didTapAddToCartButton(fromProductCatalogCell cell: ProductCatalogCell)
}

class ProductCatalogCell: UICollectionViewCell {

  //MARK: - Properties
  
  //Delegate
  weak var productCatalogCellDelegate: ProductCatalogCellDelegate?
  
  //View Container
  @IBOutlet weak var containerView: UIView!
  
  //Image properties
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  //Product Information
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productDescriptionLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  //Add to Cart Button
  @IBOutlet weak var addToCartButton: UIButton!
  
  
  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //Add drop shadow to the cell
    backgroundColor = .clear
    addDropShadow(
      opacity: 0.23,
      radius: 4,
      offset: CGSize.zero,
      lightColor: .darkGray,
      darkColor: .white
    )
    
    setupThumbnail()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    //Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
  
  //MARK: - Setup UI Methods
  func setupThumbnail() {
    productImageView.addCornerRadius(5)
  }
  
  //MARK: - Button Actions
  @IBAction func addToCartButtonAction(_ sender: UIButton) {
    
    //Animate the cell's Add To Cart button being tapped
    sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    sender.isEnabled = false
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
      sender.transform = CGAffineTransform.identity
    },
      completion: { success in
      if success { sender.isEnabled = true }
    })
    
    productCatalogCellDelegate?.didTapAddToCartButton(fromProductCatalogCell: self)
  }
}
