/*
 ProductCollectionCell.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 This is the cell from ProductOverviewViewController's collecionView
 */

import UIKit

class ProductCollectionCell: UICollectionViewCell {

  //MARK: - Properties
  
  //Container View
  @IBOutlet weak var containerView: UIView!
  
  //Product Collection Image
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  //Product Collection Name
  @IBOutlet weak var collectionNameLabel: UILabel!
  
  
  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()

    //Customize the edge of the ContainerView
    containerView.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray
    )
    containerView.addCornerRadius(5)
    
    //Add drop shadow to the cell
    backgroundColor = .clear
    addDropShadow(
      opacity: 0.23,
      radius: 4,
      offset: CGSize.zero,
      lightColor: .darkGray,
      darkColor: .white
    )
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    //Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
}
