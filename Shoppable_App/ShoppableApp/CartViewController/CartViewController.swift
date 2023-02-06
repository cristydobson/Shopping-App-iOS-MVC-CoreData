/*
 CartViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 Display the products in the Shopping Cart on a TableView
 */

import UIKit
import UserNotifications

//Delegate
protocol CartViewControllerDelegate: AnyObject {
  func didTapRemoveItemFromCartController(_ count: Int, from index: Int)
  func didUpdateItemQuantityFromCartController(_ count: Int, with updatedArray: [ProductDictionary])
  func updateItemsInShoppingCartIDs(on viewController: CartViewController)
}

class CartViewController: UIViewController {

  //MARK: - Properties ******
  
  var screenTitle = ""
  
  //Delegate
  weak var cartViewControllerDelegate: CartViewControllerDelegate?
  
  //UserDefaults
  let itemsInShoppingCartArrayKey = "itemsInShoppingCartArray"
  
  //Observer Name
  var updateShoppingCartObserverName = "updateShoppingCartObserver"
  var reloadShoppingTableView = false
  
  //Blur View
  @IBOutlet weak var blurView: UIView!
  
  //Shopping Cart Table View
  @IBOutlet weak var shoppingCartTableView: UITableView!
  let shoppingCartCellID = "CartProductCell"
  let zeroInsets = UIEdgeInsets.zero
  
  //Total Shopping Amount
  @IBOutlet weak var totalTitleLabel: UILabel!
  @IBOutlet weak var totalShoppingAmountLabel: UILabel!
  
  //Products
  var productCollections: [ProductCollection] = []
  
  //Items in the Shopping Cart
  var itemsInShoppingCartIDs: [ProductDictionary] = []
  var itemsInShoppingCart: [Product] = []
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  //Change Product Quantity
  var quantityPickerView: QuantityPickerView?
  var changedQuantityOnCellIndexPath: IndexPath?
  
  
  //MARK: - View Controller Life Cycle ******
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = screenTitle
    
    //Add a Tap Gesture to BlurView to dismiss PickerView
    setupViewTapGesture(for: blurView,
                          withAction: #selector(didCancelPickerView))
    
    //Get Product Objects from the IDs stored in UserDefaults
    getProductsInShoppingCartArray(from: itemsInShoppingCartIDs)
    
    //Setup Shopping Cart TableView
    setupProductsTableViewInsets()
    setupTableView(shoppingCartCellID, for: shoppingCartTableView, in: self)

    //Shopping Cart total price Labels
    setupTotalPriceTitleLabel()
    setupTotalPriceLabel()
    
    //Shopping Cart update observer
    setupCartUpdateOberserver()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    /*
     If the items in the Shopping Cart have been updated from
     another ViewController, then reload the UI
     */
    if reloadShoppingTableView {
      reloadShoppingTableView = false
      setupTotalPriceLabel()
      getProductsInShoppingCartArray(from: itemsInShoppingCartIDs)
      shoppingCartTableView.reloadData()
    }
  }
  
  
  //MARK: - View transition ******
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    /*
     Allow the large title in the navigationBar to go back
     to normal size on the view's transition to portrait orientation
     */
    coordinator.animate { (_) in
      self.navigationController?.navigationBar.sizeToFit()
    }
  }
  
  
  //MARK: - Setup UI ******
  func setupProductsTableViewInsets() {
    shoppingCartTableView.layoutMargins = zeroInsets
    shoppingCartTableView.separatorInset = zeroInsets
    shoppingCartTableView.contentInset = UIEdgeInsets(top: 24, left: 0,
                                                      bottom: 24, right: 0)
  }
  
  func setupTotalPriceTitleLabel() {
    totalTitleLabel.text = NSLocalizedString("Total",
                                             comment: "Total price label title in CartViewController")
  }
  
  func setupTotalPriceLabel() {
    //Get the total price from UserDefaults and display it
    let localeCurrency = Locale.current.currency?.identifier
    let totalPriceAmount = getShoppingCartTotal()
    totalShoppingAmountLabel.text = totalPriceAmount.toCurrencyFormat(in: localeCurrency!)
  }
  
  
  //MARK: - Setup Background Tap Gesture ******
  //Add a Tap Gesture to a view
  func setupViewTapGesture(for aView: UIView, withAction action: Selector?) {
    let blurViewTap = UITapGestureRecognizer(
      target: self,
      action: action
    )
    blurViewTap.cancelsTouchesInView = false
    aView.addGestureRecognizer(blurViewTap)
  }
  
  //Tap gesture action
  @objc func didCancelPickerView() {
    dismissPickerView()
  }
  
  
  //MARK: - Setup Observer ******
  /*
   Add an Observer to update the CartViewController data and UI when
   other ViewControllers have changed the item count in the
   Shopping Cart.
   */
  func setupCartUpdateOberserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateShoppingCart(_:)),
      name: Notification.Name(updateShoppingCartObserverName),
      object: nil
    )
  }
  
  
  //MARK: - Quantity PickerView Setup ******
  //Setup Quantity PickerView
  func setupQuantityPickerView() {
    quantityPickerView = QuantityPickerView()
    quantityPickerView?.setupPickerView()
    quantityPickerView?.quantityPickerViewDelegate = self
  }
  
}


//MARK: - Get Products in Shopping Cart ******
extension CartViewController {
  
  /*
   Get the products from the Shopping Cart in his own View Controller
   to avoid unnecessary operations, in case the user never taps on
   the Cart TabBar item.
   */
  func getProductsInShoppingCartArray(from array: [ProductDictionary]) {
    
    itemsInShoppingCart = []
    
    for item in array {
      /*
       1.- Make sure there's a product ID
       2.- Get the collection type
       3.- Get the product array of the correct collection type
       4.- Find the product in the Shopping Cart
       */
      
      let productID = getShoppingCartItemID(from: item) 
      let collectionType = getShoppingCartItemType(from: item)
      if
        let collection = getProductCollection(from: productCollections, of: collectionType),
        let product = getProductInShoppingCart(productID, from: collection)
      {
        itemsInShoppingCart.append(product)
      }
      
    }
  }
  
  //Get the product array of the correct collection type
  func getProductCollection(from array: [ProductCollection], of type: String) -> ProductCollection? {
    for collection in array {
      if collection.type == type {
        return collection
      }
    }
    return nil
  }
  
  //Find the product in the Shopping Cart
  func getProductInShoppingCart(_ productID: String, from collection: ProductCollection) -> Product? {
    
    //Get the products array from the collection type
    let productsArray = collection.products
    
    //Loop throught the array to find the product in the ShoppingCart
    for product in productsArray {
      if product.id == productID {
        
        //If you find it, add it to the itemsInShoppingCart array
        return product
      }
    }
    
    return nil
  }
  
}


//MARK: - Remove products from the Shopping Cart ******
extension CartViewController {
  
  //Remove a product from the Shopping Cart
  func removeItemFromShoppingCart(from index: Int) {
    
    //Updates the Cart's TabBar Item badge
    let currentItemIdDictionary = itemsInShoppingCartIDs[index]
    
    //Get how many of the same product are in the Shopping Cart
    let itemCount = getProductCountInShoppingCart(from: currentItemIdDictionary)
    
    //Remove product from Shopping Cart in TabBarController
    cartViewControllerDelegate?.didTapRemoveItemFromCartController(itemCount, from: index)
    
    //Update the total price label
    updateTotalPriceLabel(from: index, and: -itemCount)
    
    //Remove item from the ShoppingCart arrays
    updateRemovedItemsInShoppingCartArrays(for: index)
    
    //Reload the ShoppingCartTableView
    shoppingCartTableView.reloadData()
    
  }
  
  //Update itemsInShoppingCartIDs array
  func updateRemovedItemsInShoppingCartArrays(for index: Int) {
    itemsInShoppingCartIDs.remove(at: index)
    itemsInShoppingCart.remove(at: index)
    updateShoppingCartArrayInUserDefaults()
  }
  
}


//MARK: - Update Shopping Cart product count ******
extension CartViewController {
  
  //Update the product count in the Shopping Cart
  func updateProductInCartCount(for index: Int, with newItemCount: Int) {
    
    let currentItemIdDictionary = itemsInShoppingCartIDs[index]
    
    //Get how many of the same product are in the Shopping Cart
    let itemCount = getProductCountInShoppingCart(from: currentItemIdDictionary)
    
    //Update the product's count on the ShoppingCart array
    updateProductCountInShoppingCart(newItemCount, on: index)
    
    //Delta between old and new product count values
    let newCount = newItemCount - itemCount
    
    //Make sure the product quantity has changed
    if newCount > 0 {
      //Update the Cart's TabBar Item badge
      cartViewControllerDelegate?.didUpdateItemQuantityFromCartController(
        newCount,
        with: itemsInShoppingCartIDs
      )
      
      //Update the Shopping Cart array in UserDefaults
      updateShoppingCartArrayInUserDefaults()
      
      //Update the total price label
      updateTotalPriceLabel(from: index, and: newCount)
      
      shoppingCartTableView.reloadData()
    }
    
  }
  
  //Update the product's count on the ShoppingCart array
  func updateProductCountInShoppingCart(_ newItemCount: Int, on index: Int) {
    itemsInShoppingCartIDs[index].updateValue(
      newItemCount as AnyObject,
      forKey: UserDefaultsKeys.inShoppingCartCount.rawValue
    )
  }
  
  //Update the Shopping Cart array in UserDefaults
  func updateShoppingCartArrayInUserDefaults() {
    UserDefaults.standard.set(
      itemsInShoppingCartIDs,
      forKey: itemsInShoppingCartArrayKey
    )
  }
  
  //Update the total price
  func updateTotalPrice(from productIndex: Int, and itemCount: Int) -> String {

    let currentProduct = itemsInShoppingCart[productIndex]
    let currency = currentProduct.price.currency
    let price = currentProduct.price.value
    let totalPrice = price.byItemCount(itemCount)
    updateTheShoppingCartTotal(with: totalPrice)
    
    return getShoppingCartTotal().toCurrencyFormat(in: currency)
  }
  
  //Update the total price label
  func updateTotalPriceLabel(from productIndex: Int, and itemCount: Int) {
    let newPrice = updateTotalPrice(from: productIndex, and: itemCount)
    totalShoppingAmountLabel.text = newPrice
  }
  
  //User changed the product quantity in PickerView
  func userDidChangePickerView(with value: Int ) {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      cell.newPickerValue = value
    }
  }
  
}


//MARK: - UITableViewDelegate, UITableViewDataSource ******
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
  
  //1 section
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  //All products in the Shopping Cart in 1 section
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsInShoppingCart.count
  }
  
  //Load the Product Cell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCartCellID, for: indexPath) as! CartProductCell
    let index = indexPath.row
    
    //Become the cell's delegate
    cell.cartProductCellDelegate = self
    
    //Product to load in the current cell
    let product = itemsInShoppingCart[index]
    
    //Add the name of the product
    cell.productNameLabel.attributedText = getAttributedName(from: product,
                                                             withSize: 18)
    
    //Add the itemsInShoppingCart count
    let productInShoppingCartDict = itemsInShoppingCartIDs[index]
    let inShoppingCartCount = getProductCountInShoppingCart(from: productInShoppingCartDict)
    cell.changeQuantityButton.text = "\(inShoppingCartCount)"
    cell.itemCountInShoppingCart = inShoppingCartCount
    
    //Add the price of the product
    let currency = product.price.currency
    let price = product.price.value
    let multipliedPriceValue = price.byItemCount(inShoppingCartCount)
    cell.productPriceLabel.text = multipliedPriceValue.toCurrencyFormat(in: currency)
    
    //Load the image of the product from a URL
    if let imageURL = canCreateImageUrl(from: product) {
      
      //Attempt to load image
      let token = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          
          //The UI must be accessed through the main thread
          DispatchQueue.main.async {
            cell.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      
      /*
       When the cell is being reused, cancel loading the image.
       Use [unowned self] to avoid retention of self
       in the cell's onReuse() closure.
       */
      cell.onReuse = { [unowned self] in
        if let token = token {
          self.imageLoader?.cancelImageDownload(token)
        }
      }
    }
    
    return cell
  }
  
  //Swipe left to display "Delete" product button
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let removeItemAction = UIContextualAction(style: .normal, title: "") { action, sourceView, completionHandler in
      self.removeItemFromShoppingCart(from: indexPath.row)
      completionHandler(true)
    }
    
    removeItemAction.backgroundColor = .red
    removeItemAction.image = UIImage(systemName: "xmark")
    
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeItemAction])
    return swipeConfiguration
  }
  
  //Set the cell's height
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
  
  
}

//MARK: - CartProductCellDelegate ******
extension CartViewController: CartProductCellDelegate {
  
  //The user tapped "Remove Item" on the cell's "Options" button menu
  func didRemoveItemFromShoppingCart(from cell: CartProductCell) {
    
    //Find the product index before removing it
    if let index = shoppingCartTableView.indexPath(for: cell)?.row {
      removeItemFromShoppingCart(from: index)
    }
  }
  
  //The user tapped on the changeQuantity button to display the pickerView
  func didTapChangeQuantityButton(from cell: CartProductCell) {
    
    /*
     Attach the pickerView and its toolBar to the
     changeQuantityButton
     */
    addPickerViewToChangeQuantityButton(for: cell)
    
    //Display a blurred background view
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    
    /*
     Store the current cell's indexPath to be able
     to update its product count in the Shopping Cart later
     */
    changedQuantityOnCellIndexPath = shoppingCartTableView.indexPath(for: cell)
    
    //Show the product count in the PickerView
    if let cellValue = Int(cell.changeQuantityButton.text!) {
      quantityPickerView?.selectRow(
        cellValue-1,
        inComponent: 0,
        animated: false
      )
    }
  }
  
  /*
   Attach the pickerView and its toolBar to the
   changeQuantityButton textfield
   */
  func addPickerViewToChangeQuantityButton(for cell: CartProductCell) {
    if quantityPickerView == nil { setupQuantityPickerView() }
    cell.changeQuantityButton.inputView = quantityPickerView
    cell.changeQuantityButton.inputAccessoryView = quantityPickerView?.pickerToolBar
  }
}


//MARK: - Add To Cart Observer ******
extension CartViewController {
  
  /*
   The observer setup in ViewDidLoad() calls this method when
   the products in the Shopping Cart have been updated
   elsewhere
   */
  @objc func updateShoppingCart(_ notification: Notification) {
    cartViewControllerDelegate?.updateItemsInShoppingCartIDs(on: self)
    reloadShoppingTableView = true
  }
}


//MARK: - QuantityPickerViewDelegate ******
extension CartViewController: QuantityPickerViewDelegate {
  
  //User Tapped "Done" on the PickerView
  func didTapDoneButtonOnToolBar() {
    tappedDoneButtonOnPicker()
  }
  
  //User Tapped "Cancel" on the PickerView
  func didTapCancelButtonOnToolBar() {
    dismissPickerView()
  }
  
  //User updated the product quantity in PickerView
  func didUpdatePickerView(with value: Int) {
    userDidChangePickerView(with: value)
  }
  
  /*
   Action triggered when the pickerView's
   toolBar button "Done" is tapped
   */
  func tappedDoneButtonOnPicker() {
    
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      //Dismiss the PickerView
      cell.changeQuantityButton.resignFirstResponder()
      
      //Hide the background BlurView
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
      
      //Check if the product quantity has changed
      checkProductQuantityUpdate(for: cell, on: cellIndexPath.row)
      
      //Remover the PickerView and its ToolBar from the cell
      removePickerViewFromCell(cell)
    }
  }
  
  //Check if the product quantity in the Shopping Cart has changed
  func checkProductQuantityUpdate(for cell: CartProductCell, on index: Int) {
    
    let newQuantityValue = cell.newPickerValue
    if
      newQuantityValue > 0,
      cell.itemCountInShoppingCart != newQuantityValue
    {
      //Update product count in the cell
      cell.changeQuantityButton.text = "\(newQuantityValue)"
      cell.itemCountInShoppingCart = newQuantityValue
      cell.newPickerValue = 0
      
      /*
       Update the product count in itemsInShoppingCartIDs array
       and UserDefaults
       */
      updateProductInCartCount(for: index, with: newQuantityValue)
    }
  }
  
  /*
   Called when the PickerView's "Cancel" button is tapped
   or the blurView is tapped to dismiss the PickerView
   */
  func dismissPickerView() {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      //Dismiss the PickerView
      cell.changeQuantityButton.resignFirstResponder()
      
      //Update product count in the cell
      cell.newPickerValue = 0
      
      //Hide the background BlurView
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
      
      //Remover the PickerView and its ToolBar from the cell
      removePickerViewFromCell(cell)
    }
  }
  
  //Remover the PickerView and its ToolBar from the cell
  func removePickerViewFromCell(_ cell: CartProductCell) {
    cell.changeQuantityButton.inputView = nil
    cell.changeQuantityButton.inputAccessoryView = nil
  }
  
}

