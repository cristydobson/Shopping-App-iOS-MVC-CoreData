/*
    TabBarController.swift
    ShoppableApp

    Created on 1/19/23.
 
    A TabBarController with 2 child Navigation Controllers
*/


import UIKit
import CoreData


// Describes a product object's type
typealias ProductDictionary = [String:AnyObject]


class TabBarController: UITabBarController {

  // MARK: - Properties
  
  // Core Data
  lazy var coreDataStack = CoreDataStack()
  var coreDataService: CoreDataService!
  
  // Tab Bar
  var currentTabIndex = 0
  
  // Image Loader
  var imageLoader: ImageDownloader?
  
  // Products
  var productCollections: [ProductCollection] = []
  
  // ShoppingCart
  var shoppingCartProducts: [ShoppingCartProduct] = []
  
  
  // MARK: - View Controller's Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TabBar's Delegate
    delegate = self
    
    // Image Loader
    imageLoader = ImageDownloader()
    
    // Load JSON Data
    loadJsonData()
    
    // Core Data
    coreDataService = CoreDataService(coreDataStack: coreDataStack)
    loadShoppingCartFromCoreData()
    
    // Become the Children's delegate
    setupChildrenDelegates()
    
    // Setup the TabBar items title and style
    customizeTabBarItems()
    
    // Set up the Cart TabBar item badge
    setupInitialCartTabBarItemBadge()
    
    
  }

}


// MARK: - Setup UI

extension TabBarController {
  
  // Setup the TabBar items title and style
  func customizeTabBarItems() {
    
    let tabBarItems = tabBar.items
    tabBarItems?[0].title = NSLocalizedString(
      "Collections", comment: "Collections TabBar item title")
    tabBarItems?[1].title = NSLocalizedString(
      "Cart", comment: "Cart TabBar item title")
    tabBar.tintColor = .label
    tabBar.unselectedItemTintColor = .systemGray3
  }
  
  /*
   Set the Shopping Cart's tabBar item badge if the customer
   has products on their Shopping Cart.
   
   The color of the badge will remain its default RED color
   to give the customer a sense of urgency to go to the
   Shopping Cart and buy.
   */
  func setupCartTabBarItemBadge(with count: Int) {
    let cartTabItem = tabBar.items?.last
    cartTabItem?.badgeValue = count > 0 ? "\(count)" : nil
  }
  
  // Cart's TabBarItem badge on app launch
  func setupInitialCartTabBarItemBadge() {
    let count = coreDataService.getShoppingCartCount()
    setupCartTabBarItemBadge(with: count)
  }
  
}


// MARK: - Setup Children Delegates

/*
 Become the delegate of children's top controllers
 */
extension TabBarController {
  
  func setupChildrenDelegates() {
    setupProductOverviewVcDelegate()
    setupCartVcDelegate()
  }
  
  // Child 1
  func setupProductOverviewVcDelegate() {
    
    if
      let navController = getChildNavigationController(with: 0),
      let rootController = navController.topViewController as? ProductOverviewViewController
    {
      navController.navigationBar.prefersLargeTitles = true
      rootController.productOverviewViewControllerDelegate = self
      rootController.productCollections = productCollections
      rootController.imageLoader = imageLoader
    }
  }
  
  // Child 2
  func setupCartVcDelegate() {
    
    if
      let navController = getChildNavigationController(with: 1),
      let rootController = navController.topViewController as? CartViewController
    {
      rootController.cartViewControllerDelegate = self
      rootController.coreDataService = coreDataService
      rootController.shoppingCartProducts = shoppingCartProducts
      rootController.imageLoader = imageLoader
    }
  }
  
  // Get a child NavigationController
  func getChildNavigationController(with index: Int) -> UINavigationController? {
    
    if let navController = children[index] as? UINavigationController {
      return navController
    }
    return nil
  }
  
}


// MARK: - Load the Products data

extension TabBarController {
  
  // Load the data from the products.json file
  func loadJsonData() {
    let products = JsonLoader.returnProductCollectionTypeArray(
      from: "products")
    productCollections = products
  }
  
}


// MARK: - CoreData Methods

extension TabBarController {
  
  // Fetch the Shopping Cart from CoreData
  func loadShoppingCartFromCoreData() {
    shoppingCartProducts = coreDataService.getProductArray()
  }
  
  // Save new products in CoreData's ShoppingCart
  func saveToShoppingCartInCoreData(product: Product) {

    if let newProduct = coreDataService.getProduct(product.id, from: shoppingCartProducts) {
      // If the product is already in the Shopping Cart
      coreDataService.updateCount(
        for: newProduct, by: 1)
    }
    else {
      // Create a new ShoppingCartProduct
      let newProduct = coreDataService.saveNewProduct(product)
      shoppingCartProducts.append(newProduct)
    }
    
    coreDataService.updateProductCount(by: 1)
    
    // Update the total price in Shopping Cart
    let price = product.price.value
    coreDataService.updateTotalAmount(by: price)
  }

}
