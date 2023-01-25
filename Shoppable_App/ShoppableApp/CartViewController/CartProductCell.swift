/*
 CartProductCell.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
 This is the cell from CartViewController's tableView
 */

import UIKit

//Delegate
protocol CartProductCellDelegate: AnyObject {
  func didRemoveItemFromShoppingCart(from cell: CartProductCell)
  func didTapChangeQuantityButton(from cell: CartProductCell)
}

class CartProductCell: UITableViewCell {

  //MARK: - Properties
  
  //Delegate
  weak var cartProductCellDelegate: CartProductCellDelegate?
  
  //Background View
  @IBOutlet weak var bgView: UIView!
  
  //Product Image
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  //Product Info
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  //Options button
  @IBOutlet weak var optionsButton: UIButton!
  var optionsButtonMenu: UIMenu?
  var removeItemFromShoppingCart: UICommand?
  
  //Change quantity button
  @IBOutlet weak var changeQuantityButton: UITextField!
  
  //Item Count in Shopping Cart
  var itemCountInShoppingCart = 0
  var newPickerValue = 0
  
  
  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //Change item in Shopping List count delegate
    changeQuantityButton.delegate = self
    
    //Add drop shadow to the cell
    backgroundColor = .clear
    selectionStyle = .none
    bgView.addDropShadow(
      opacity: 0.23,
      radius: 4,
      offset: CGSize.zero,
      lightColor: .gray,
      darkColor: .white
    )
    
    //Price label font
    productPriceLabel.font = UIFont.systemFont(ofSize: 16,
                                               weight: .semibold)
    
    //Customize the edge of the ContainerView
    changeQuantityButton.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray
    )
    changeQuantityButton.addCornerRadius(changeQuantityButton.frame.height/2)
    
    //Setup UI
    setupOptionsButton()
    setupThumbnail()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    itemCountInShoppingCart = 0
    
    //Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
  
  //MARK: - Setup UI Methods
  func setupOptionsButton() {
    /*
     Add the "Remove Item" from Shopping Cart command in the
     "Options" button menu
     */
    removeItemFromShoppingCart = UICommand(
      title: NSLocalizedString("Remove Item",
                               comment: "Shopping Cart cell -> options button -> pull-down menu command."),
      image: UIImage(systemName: "trash"),
      action: #selector(removeItemFromShoppingCartAction)
    )
    optionsButtonMenu = UIMenu(
      options: .displayInline,
      children: [removeItemFromShoppingCart!]
    )
    optionsButton.menu = optionsButtonMenu
  }
  
  @objc func removeItemFromShoppingCartAction() {
    cartProductCellDelegate?.didRemoveItemFromShoppingCart(from: self)
  }
  
  func setupThumbnail() {
    productImageView.addCornerRadius(5)
  }
    
  //MARK: - Button Actions
  @IBAction func optionsButtonAction(_ sender: UIButton) {
  }
}


//MARK: - UITextFieldDelegate
extension CartProductCell: UITextFieldDelegate {
  /*
   Tell the CartViewController that the user tapped on
   the changeQuantityButton textfield,
   so it displays the pivkerView
   */
  func textFieldDidBeginEditing(_ textField: UITextField) {
    cartProductCellDelegate?.didTapChangeQuantityButton(from: self)
  }
}
