/*
 CartViewController.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/19/23.
 
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

  //MARK: - Properties
  
  //Delegate
  weak var cartViewControllerDelegate: CartViewControllerDelegate?
  
  //Product Information Class
  var productInfoClass: ProductInformation?
  
  //UserDefaults
  let itemsInShoppingCartArrayKey = "itemsInShoppingCartArray"
  
  //Observer Names
  var updateShoppingCartObserverName = "updateShoppingCartObserver"
  var reloadCatalogObserverName = "reloadCatalogObserver"
  var reloadShoppingTableView = false
  
  //Blur View
  @IBOutlet weak var blurView: UIView!
  var blurViewTap: UITapGestureRecognizer!
  
  //Shopping Cart Table View
  @IBOutlet weak var shoppingCartTableView: UITableView!
  let shoppingCartCellID = "CartProductCell"
  
  //Total Shopping Amount
  @IBOutlet weak var totalTitleLabel: UILabel!
  @IBOutlet weak var totalShoppingAmountLabel: UILabel!
  var shoppingCartInfoClass: ShoppingCartInfo?
  
  //Products
  var productCollections: [ProductDictionary] = []
  
  //Items in the Shopping Cart
  var itemsInShoppingCartIDs: [ProductDictionary] = []
  var itemsInShoppingCart: [ProductDictionary] = []
  
  //Image Loader
  var imageLoader: ImageDownloader?
  
  //Change Product Quantity
  let amountRange = 1...1000
  let quantityPickerView = UIPickerView()
  var changedQuantityOnCellIndexPath: IndexPath?
  var toolBar: UIToolbar?
  
  
  //MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Navigation Bar
    title = NSLocalizedString("Shopping Cart", comment: "Cart View Controller title")
    
    //Shopping Cart info class
    shoppingCartInfoClass = ShoppingCartInfo()
    
    //Product Information Class
    productInfoClass = ProductInformation()
    
    //Image Loader
    imageLoader = ImageDownloader()
    
    //Blur View tap gesture to dismiss PickerView
    blurViewTap = UITapGestureRecognizer(
      target: self,
      action: #selector(self.didCancelPickerView)
    )
    blurViewTap.cancelsTouchesInView = false
    blurView.addGestureRecognizer(blurViewTap!)
    
    //Get Product Dictionaries from the IDs stored in UserDefaults
    getProductsInShoppingCartInfo(from: itemsInShoppingCartIDs)
    
    //Setup Shopping Cart TableView
    shoppingCartTableView.layoutMargins = UIEdgeInsets.zero
    shoppingCartTableView.separatorInset = UIEdgeInsets.zero
    shoppingCartTableView.contentInset = UIEdgeInsets(top: 24, left: 0,
                                                      bottom: 24, right: 0)
    let cellNib = UINib(nibName: shoppingCartCellID, bundle: nil)
    shoppingCartTableView.register(
      cellNib,
      forCellReuseIdentifier: shoppingCartCellID
    )

    //Setup QuantityPickerView to change a product count in the cart
    quantityPickerView.delegate = self
    quantityPickerView.dataSource = self
    setupChangeQuantityPicker()
    
    //Shopping Cart total price
    totalTitleLabel.text = NSLocalizedString("Total",
                                             comment: "Total price label title in CartViewController")
    setupTotalPriceLabel()
    
    /*
     Add an Observer to update the CartViewController data and UI when
     other ViewControllers have changed the item count in the
     Shopping Cart.
     */
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateShoppingCart(_:)),
      name: Notification.Name(updateShoppingCartObserverName),
      object: nil
    )
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    /*
     If the items in the Shopping Cart have been updated from
     another ViewController, then reload the UI
     */
    if reloadShoppingTableView {
      setupTotalPriceLabel()
      getProductsInShoppingCartInfo(from: itemsInShoppingCartIDs)
      shoppingCartTableView.reloadData()
      reloadShoppingTableView = false
    }
  }
  
  //MARK: - View transition
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
  
  /*
    Get the products from the Shopping Cart in his own View Controller
    to avoid unnecessary operations, in case the user never taps on
    the Cart TabBar item.
   */
  func getProductsInShoppingCartInfo(from array: [ProductDictionary]) {
    
    itemsInShoppingCart = []
    
    for item in array {
      //Make sure there's a product ID
      if let productID = item[UserDefaultsKeys.id.rawValue] as? String {

        /*
         Check if there's a product type index to look for the item
         in the array productCollections:[ProductDictionary],
         AND that the index is within the array's bounds
         */
        if let collectionType = item[UserDefaultsKeys.productCollectionType.rawValue] as? String {
          
          //Get the array with the right product collection type
          var productCollection: ProductDictionary = [:]
          collectionLoop: for collection in productCollections {
            if
              let itemCollectionType = collection[ProductDataKeys.type.rawValue] as? String,
              itemCollectionType == collectionType
            {
              productCollection = collection
              break collectionLoop
            }
          }
          
          //Get the products array from the collection type
          if let productsArray = productCollection[ProductDataKeys.products.rawValue] as? [ProductDictionary] {
            
            //Loop throught the array to find the product for the ShoppingCart
            innerLoop: for product in productsArray {
              if
                let id = product[ProductDataKeys.id.rawValue] as? String,
                id == productID
              {
                //If you find it, add it to the array itemsInShoppingCart
                itemsInShoppingCart.append(product)
                break innerLoop
              }
            }
          }
        }
      }
    }
  }
  
  //MARK: - Update Shopping Cart items
  //Remove a product from the Shopping Cart
  func removeItemFromShoppingCart(from index: Int) {
    
    //Updates the Cart's TabBar Item badge
    let currentItemIdDictionary = itemsInShoppingCartIDs[index]
    if let itemCount = currentItemIdDictionary[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int
    {
      cartViewControllerDelegate?.didTapRemoveItemFromCartController(itemCount, from: index)
      
      //Update the total price label
      let currentProduct = itemsInShoppingCart[index]
      let currency = productInfoClass!.getProductPriceCurrency(from: currentProduct)
      let price = productInfoClass!.getProductPrice(from: currentProduct)
      let totalPrice = price * Double(itemCount)
      shoppingCartInfoClass?.updateTheShoppingCartTotal(with: -totalPrice)
      let newPrice = shoppingCartInfoClass?.getShoppingCartTotal().toCurrencyFormat(in: currency)
      totalShoppingAmountLabel.text = newPrice
    }
    
    //Remove item from the ShoppingCart array in UserDefaults
    itemsInShoppingCartIDs.remove(at: index)
    UserDefaults.standard.set(
      itemsInShoppingCartIDs,
      forKey: itemsInShoppingCartArrayKey
    )
    
    //Reload the Product TableView
    itemsInShoppingCart.remove(at: index)
    shoppingCartTableView.reloadData()
  }
  
  //Update the product count in the Shopping Cart
  func updateProductInCartCount(for index: Int, with value: Int) {
   
    let currentItemIdDictionary = itemsInShoppingCartIDs[index]
    
    //Make sure that the product count has been updated
    if
      let itemCount = currentItemIdDictionary[UserDefaultsKeys.inShoppingCartCount.rawValue] as? Int
    {
      
      //Update the product's count on the ShoppingCart array
      let updatedCount = value
      itemsInShoppingCartIDs[index].updateValue(
        updatedCount as AnyObject,
        forKey: UserDefaultsKeys.inShoppingCartCount.rawValue
      )
      
      //Updates the Cart's TabBar Item badge
      let newCount = value - itemCount
      cartViewControllerDelegate?.didUpdateItemQuantityFromCartController(
        newCount,
        with: itemsInShoppingCartIDs
      )
      
      //Update the Shopping Cart array in UserDefaults
      UserDefaults.standard.set(
        itemsInShoppingCartIDs,
        forKey: itemsInShoppingCartArrayKey
      )
      
      //Update the total price label
      let currentProduct = itemsInShoppingCart[index]
      let currency = productInfoClass!.getProductPriceCurrency(from: currentProduct)
      let price = productInfoClass!.getProductPrice(from: currentProduct)
      let totalPrice = price * Double(newCount)
      shoppingCartInfoClass?.updateTheShoppingCartTotal(with: totalPrice)
      let newPrice = shoppingCartInfoClass?.getShoppingCartTotal().toCurrencyFormat(in: currency)
      totalShoppingAmountLabel.text = newPrice
      shoppingCartTableView.reloadData()
    }
  }
  
  //MARK: - Setup UI
  func setupTotalPriceLabel() {
    //Get the total price from UserDefaults and display it
    let locale = Locale.current
    let currency = locale.currency?.identifier
    let totalPriceAmount = shoppingCartInfoClass?.getShoppingCartTotal()
    let formattedTotalPrice = totalPriceAmount?.toCurrencyFormat(in: currency!)
    totalShoppingAmountLabel.text = formattedTotalPrice
  }
  
  //Add a toolBar to the PickerView
  func setupChangeQuantityPicker() {
    
    toolBar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                      width: quantityPickerView.frame.width,
                                      height: 24))
    toolBar?.barStyle = UIBarStyle.default
    toolBar?.isTranslucent = true
    toolBar?.tintColor = .label
    toolBar?.sizeToFit()
    
    //The user is done changing a product's quantity
    let doneButton = UIBarButtonItem(
      title: NSLocalizedString("Done", comment: "Any Done button"),
      style: UIBarButtonItem.Style.done,
      target: self,
      action: #selector(tappedDoneButtonOnPicker)
    )

    let spaceButton = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
      target: nil,
      action: nil
    )
    
    //The user has canceled changing the product's quantity
    let cancelButton = UIBarButtonItem(
      title: NSLocalizedString("Cancel", comment: "Any Cancel button"),
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(didCancelPickerView)
    )
    
    toolBar?.setItems(
      [cancelButton, spaceButton, doneButton],
      animated: false
    )
    toolBar?.isUserInteractionEnabled = true
  }
  
  //Triggered when the pickerView's button "Done" is tapped
  @objc func tappedDoneButtonOnPicker() {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      cell.changeQuantityButton.resignFirstResponder()
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
      
      //Check if the product quantity has changed
      let newQuantityValue = cell.newPickerValue
      if
        newQuantityValue > 0,
        cell.itemCountInShoppingCart != newQuantityValue
      {
        //Update product count
        cell.changeQuantityButton.text = "\(newQuantityValue)"
        cell.itemCountInShoppingCart = newQuantityValue
        cell.newPickerValue = 0
        updateProductInCartCount(for: cellIndexPath.row, with: newQuantityValue)
      }
    }
  }
  
  /*
   Triggered when the PickerView's button "Cancel" is tapped
   or the blurView is tapped to dismiss the PickerView
  */
  @objc func didCancelPickerView() {
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      cell.changeQuantityButton.resignFirstResponder()
      cell.newPickerValue = 0
      blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
    }
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsInShoppingCart.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCartCellID, for: indexPath) as! CartProductCell
    
    cell.cartProductCellDelegate = self
    
    //Attach the pickerView and its toolBar to the changeQuantityButton textfield
    cell.changeQuantityButton.inputView = quantityPickerView
    cell.changeQuantityButton.inputAccessoryView = toolBar
    
    let product = itemsInShoppingCart[indexPath.row]
    
    //Add the name of the product
    let name = productInfoClass?.getProductName(from: product).uppercased()
    let attributedName = name?.toStyledString(with: 18, and: .bold)
    cell.productNameLabel.attributedText = attributedName
    
    //Add the itemsInShoppingCart count
    let productIdDict = itemsInShoppingCartIDs[indexPath.row]
    let inShoppingCartCount = productInfoClass?.getProductCountInShoppingCart(for: productIdDict, from: itemsInShoppingCartIDs)
    cell.changeQuantityButton.text = "\(inShoppingCartCount!)"
    cell.itemCountInShoppingCart = inShoppingCartCount!
    
    //Add the price of the product
    let priceCurrency = productInfoClass!.getProductPriceCurrency(from: product)
    let price = productInfoClass!.getProductPrice(from: product)
    let multipliedPriceValue = price * Double(inShoppingCartCount!)
    cell.productPriceLabel.text = multipliedPriceValue.toCurrencyFormat(in: priceCurrency)
    
    //Add the image of the product
    if
      let imageUrlString = product[ProductDataKeys.imageUrl.rawValue] as? String,
      let imageURL = URL(string: imageUrlString)
    {
      
      let token = imageLoader?.loadImage(imageURL) { result in
        do {
          let image = try result.get()
          DispatchQueue.main.async {
            cell.productImageView.image = image
          }
        }
        catch {
          print("ERROR loading image with error: \(error.localizedDescription)!")
        }
      }
      
      cell.onReuse = {
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

//MARK: - CartProductCellDelegate
extension CartViewController: CartProductCellDelegate {
  
  //The user tapped "Remove Item" on the cell's "Options" button menu
  func didRemoveItemFromShoppingCart(from cell: CartProductCell) {
    let indexPath = shoppingCartTableView.indexPath(for: cell)
    if let index = indexPath?.row as? Int {
      removeItemFromShoppingCart(from: index)
    }
  }
  
  //The user tapped on the changeQuantity button to display the pickerView
  func didTapChangeQuantityButton(from cell: CartProductCell) {
    blurView.showAnimatedAsBlur(withDuration: 0.2, delay: 0)
    changedQuantityOnCellIndexPath = shoppingCartTableView.indexPath(for: cell)
    if let cellValue = Int(cell.changeQuantityButton.text!) {
      quantityPickerView.selectRow(
        cellValue-1,
        inComponent: 0,
        animated: false
      )
    }
  }
}

//MARK: - Add To Cart Observer
extension CartViewController {
  
  /*
   The observer setup in ViewDidLoad() calls this method when
   the products in the Shopping Cart have been updated
   somewhere else
   */
  @objc func updateShoppingCart(_ notification: Notification) {
    cartViewControllerDelegate?.updateItemsInShoppingCartIDs(on: self)
    reloadShoppingTableView = true
  }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return amountRange.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row+1)"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    /*
     Update the value chosen by the user in the pickerView,
     to compare it with the old value when the pickerView is dismissed
     */
    if
      let cellIndexPath = changedQuantityOnCellIndexPath,
      let cell = shoppingCartTableView.cellForRow(at: cellIndexPath) as? CartProductCell
    {
      cell.newPickerValue = row+1
    }
  }

}
