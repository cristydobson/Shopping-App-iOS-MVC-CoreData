/*
 ProductCollectionCell.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 This is the cell from ProductOverviewViewController's collecionView
 */


import UIKit


class ProductCollectionCell: UICollectionViewCell {

  
  // MARK: - Properties
  
  // Container View
  @IBOutlet weak var containerView: UIView!
  
  // Product Collection Image
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  // Product Collection Name
  @IBOutlet weak var collectionNameLabel: UILabel!
  
  
  // MARK: - awakeFromNib
  
  override func awakeFromNib() {
    super.awakeFromNib()

    //Customize the edge of the ContainerView
    containerViewStyle()
    
    //Add drop shadow to the cell
    addDropShadowToView()
  }
  
  
  // MARK: - prepareForReuse
  
  override func prepareForReuse() {
    super.prepareForReuse()
    //Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
  
}


// MARK: - UI Style

extension ProductCollectionCell {
  
  func containerViewStyle() {
    
    containerView.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray
    )
    containerView.addCornerRadius(5)
  }
  
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
  
}
