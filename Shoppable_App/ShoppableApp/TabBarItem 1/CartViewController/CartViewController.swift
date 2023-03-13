/*
 CartViewController.swift
 ShoppableApp
 
 Created on 1/19/23.
 
 Display the products in the Shopping Cart on a TableView
 */

import UIKit
import UserNotifications
import CoreData


class CartViewController: UIViewController {

  
  // MARK: - Properties
  
  // Core Data
  var coreDataStack: CoreDataStack!
  var shoppingCart: ShoppingCart!
  var shoppingCartProducts: [ShoppingCartProduct] = []
  
  // Delegate
  weak var cartViewControllerDelegate: CartViewControllerDelegate?
  
  // Observer Name
  let updateShoppingCartObserverName = "updateShoppingCartObserver"
  var reloadShoppingTableView = false
  
  // Blur View
  @IBOutlet weak var blurView: UIView!
  
  // Shopping Cart Table View
  @IBOutlet weak var shoppingCartTableView: UITableView!
  let shoppingCartCellID = "CartProductCell"
  let zeroInsets = UIEdgeInsets.zero
  
  // Total Shopping Amount
  @IBOutlet weak var totalTitleLabel: UILabel!
  @IBOutlet weak var totalShoppingAmountLabel: UILabel!
  
  // Image Loader
  var imageLoader: ImageDownloader?
  
  // Change Product Quantity
  var quantityPickerView: QuantityPickerView?
  var changedQuantityOnCellIndexPath: IndexPath?
  
  
  // MARK: - View Controller's Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Navigation Bar
    setupNavigationBar()
    
    // Add a Tap Gesture to BlurView to dismiss PickerView
    setupViewTapGesture(
      for: blurView,
      withAction: #selector(didCancelPickerView))
    
    // Setup Shopping Cart TableView
    setupProductsTableViewInsets()
    ObjectCollectionHelper.setupTableView(
      shoppingCartCellID, for: shoppingCartTableView, in: self)

    // Shopping Cart total price Labels
    setupTotalPriceTitleLabel()
    setupTotalPriceLabel()
    
    // Shopping Cart update observer
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
      shoppingCartTableView.reloadData()
    }
  }
  
  
  // MARK: - View transition
  
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
  
}


// MARK: - Setup UI 
extension CartViewController {
  
  func setupNavigationBar() {
    title = NSLocalizedString(
      "Shopping Cart",
      comment: "Cart View Controller title")
  }
  
  func setupProductsTableViewInsets() {
    shoppingCartTableView.layoutMargins = zeroInsets
    shoppingCartTableView.separatorInset = zeroInsets
    shoppingCartTableView.contentInset = UIEdgeInsets(
      top: 24, left: 0, bottom: 24, right: 0)
  }
  
  func setupTotalPriceTitleLabel() {
    totalTitleLabel.text = NSLocalizedString(
      "Total",
      comment: "Total price label title in CartViewController")
  }
  
  func setupTotalPriceLabel() {
    // Get the total price from UserDefaults and display it
    let totalPriceAmount = shoppingCart.totalAmount
    totalShoppingAmountLabel.text = totalPriceAmount.toCurrencyFormat()
  }
  
  // Setup Quantity PickerView
  func setupQuantityPickerView() {
    quantityPickerView = QuantityPickerView()
    quantityPickerView?.setupPickerView()
    quantityPickerView?.quantityPickerViewDelegate = self
  }
  
}


// MARK: - Add Tap Gesture to BlurView
extension CartViewController {
  
  // Add a Tap Gesture to a view
  func setupViewTapGesture(for aView: UIView, withAction action: Selector?) {
    let blurViewTap = UITapGestureRecognizer(
      target: self, action: action)
    blurViewTap.cancelsTouchesInView = false
    aView.addGestureRecognizer(blurViewTap)
  }
  
  // Tap gesture action
  @objc func didCancelPickerView() {
    dismissPickerView()
  }
  
}


// MARK: - Remove products from the Shopping Cart
extension CartViewController {
  
  // Remove a product from the Shopping Cart
  func removeItemFromShoppingCart(from index: Int) {
    
    let product = shoppingCartProducts[index]
    
    // Get how many of the same product are in the Shopping Cart
    let itemCount = Int(product.count)
    
    // Update the total price
    updateTotalPriceInCoreData(with: product.price, itemCount: -itemCount)
    
    // Update the total price label
    setupTotalPriceLabel()
    
    // Remove product from Shopping Cart in TabBarController
    deleteShoppingCartProductFromCoreData(from: index)
    cartViewControllerDelegate?.updateShoppingCartProducts(shoppingCartProducts)
    
    // Reload the ShoppingCartTableView
    shoppingCartTableView.reloadData()
  }
  
  func deleteShoppingCartProductFromCoreData(from index: Int) {
    let product = shoppingCartProducts[index]
    let count = product.count
    
    shoppingCart.productCount -= count
    
    coreDataStack.managedContext.delete(product)
    coreDataStack.saveContext()
    
    shoppingCartProducts.remove(at: index)
  }
  
}


// MARK: - Update Shopping Cart product count
extension CartViewController {
  
  // Update the product count in the Shopping Cart
  func updateProductInCartCount(for index: Int, with newItemCount: Int) {
    
    let currentProduct = shoppingCartProducts[index]
    
    // Get how many of the same product were in the Shopping Cart
    let oldItemCount = Int(currentProduct.count)
    
    // Delta between old and new product count values
    let delta =  newItemCount - oldItemCount
    
    // Make sure the product quantity has changed
    if delta != 0 {
      updateShoppingCart(with: newItemCount, delta: delta, on: index)
    }
    
  }
  
  // User did update Shopping Cart products
  func updateShoppingCart(with newCount: Int, delta: Int, on index: Int) {

    // Update the product's count on the ShoppingCart
    updateCountInShoppingCartProductInCoreData(newCount, on: index)
    updateTotalShoppingCartProductCountInCoreData(with: delta)

    // Update the total product price
    let productPrice = shoppingCartProducts[index].price
    updateTotalPriceInCoreData(with: productPrice, itemCount: delta)
    
    // Update the total price label
    setupTotalPriceLabel()
    
    // Update the Cart's TabBar Item badge
    cartViewControllerDelegate?.updateTabBarBadge()
    
    shoppingCartTableView.reloadData()
  }
  
  func updateTotalShoppingCartProductCountInCoreData(with itemCount: Int) {
    shoppingCart.productCount += Int64(itemCount)
    coreDataStack.saveContext()
  }
  
  // Update the product's count on the ShoppingCart Product
  func updateCountInShoppingCartProductInCoreData(_ newItemCount: Int, on index: Int) {
    let product = shoppingCartProducts[index]
    product.count = Int64(newItemCount)
    coreDataStack.saveContext()
  }
  
  func updateTotalPriceInCoreData(with amount: Double, itemCount: Int) {
    let newAmount = amount.byItemCount(itemCount)
    shoppingCart.totalAmount += newAmount
    coreDataStack.saveContext()
  }
  
}




