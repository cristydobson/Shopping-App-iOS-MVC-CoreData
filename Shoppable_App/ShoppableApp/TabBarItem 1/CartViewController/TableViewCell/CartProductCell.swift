/*
 CartProductCell.swift
 
 
 Created by Cristina Dobson
 
 This is the cell from CartViewController's tableView
 */


import UIKit


class CartProductCell: UITableViewCell {

  
  // MARK: - Properties
  
  // Delegate
  weak var cartProductCellDelegate: CartProductCellDelegate?
  
  // Background View
  @IBOutlet weak var bgView: UIView!
  
  // Product Image
  @IBOutlet weak var productImageView: UIImageView!
  var onReuse: () -> Void = {}
  
  // Product Info
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  
  // Options button
  @IBOutlet weak var optionsButton: UIButton!
  var optionsButtonMenu: UIMenu?
  var removeItemFromShoppingCart: UICommand?
  
  // Change quantity button
  @IBOutlet weak var changeQuantityButton: UITextField!
  
  // Item Count in Shopping Cart
  var itemCountInShoppingCart = 0
  var newPickerValue = 0
  
  
  // MARK: - awakeFromNib
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Setup Options button
    setupOptionsButton()
    
    // Add drop shadow to the cell
    addDropShadowToBgView()
    
    // UI Style
    priceLabelStyle()
    thumbnailStyle()
    
    // Setup Change Quantity button
    changeQuantityButton.delegate = self
    changeQuantityButtonStyle()

  }
  
  
  // MARK: - prepareForReuse
  
  override func prepareForReuse() {
    super.prepareForReuse()
    itemCountInShoppingCart = 0
    
    //Get the imageView ready for a new image load
    onReuse()
    productImageView.image = nil
  }
  
  
  // MARK: - Button Actions
  
  @IBAction func optionsButtonAction(_ sender: UIButton) { }
  
}


// MARK: - UI Style

extension CartProductCell {
  
  // Add drop shadow to background view
  func addDropShadowToBgView() {
    
    backgroundColor = .clear
    selectionStyle = .none
    
    bgView.addDropShadow(
      opacity: 0.23,
      radius: 4,
      offset: CGSize.zero,
      lightColor: .gray,
      darkColor: .white)
  }
  
  func thumbnailStyle() {
    productImageView.addCornerRadius(5)
  }
  
  func priceLabelStyle() {
    productPriceLabel.font = UIFont.systemFont(ofSize: 16,
                                               weight: .semibold)
  }
  
  // Change Quantity button style
  func changeQuantityButtonStyle() {
    
    changeQuantityButton.addBorderStyle(
      borderWidth: 1,
      borderColor: .imageBorderGray)
    
    changeQuantityButton.addCornerRadius(
      changeQuantityButton.frame.height/2)
  }
}


// MARK: - Setup UI

extension CartProductCell {
  
  func setupOptionsButton() {
    /*
     Add the "Remove Item" from Shopping Cart command in the
     "Options" button menu
     */
    removeItemFromShoppingCart = UICommand(
      title: NSLocalizedString(
        "Remove Item",
        comment: "Shopping Cart cell -> options button -> pull-down menu command."),
      image: UIImage(systemName: "trash"),
      action: #selector(removeItemFromShoppingCartAction))
    
    optionsButtonMenu = UIMenu(
      options: .displayInline,
      children: [removeItemFromShoppingCart!])
    
    optionsButton.menu = optionsButtonMenu
  }
  
  // OptionsButton RemoveItem command action
  @objc func removeItemFromShoppingCartAction() {
    cartProductCellDelegate?.didRemoveItemFromShoppingCart(from: self)
  }
  
}



