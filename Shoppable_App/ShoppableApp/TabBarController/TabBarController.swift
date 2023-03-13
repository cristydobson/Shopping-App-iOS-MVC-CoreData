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
  lazy var coreDataStack = CoreDataStack(modelName: "ShoppableApp")
  
  // Tab Bar
  var currentTabIndex = 0
  
  // Image Loader
  var imageLoader: ImageDownloader?
  
  // Products
  var productCollections: [ProductCollection] = []
  
  // ShoppingCart
  var shoppingCart: ShoppingCart!
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
    setupCartTabBarItemBadge(with: Int(shoppingCart.productCount))
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
      rootController.coreDataStack = coreDataStack
      rootController.shoppingCart = shoppingCart
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

    let cartName = "ShoppingCart"

    let cartFetchRequest: NSFetchRequest<ShoppingCart> = ShoppingCart.fetchRequest()
    cartFetchRequest.predicate = NSPredicate(
      format: "%K == %@", #keyPath(ShoppingCart.name), cartName)

    do {
      let results = try coreDataStack.managedContext.fetch(cartFetchRequest)

      if results.count > 0 {
        shoppingCart = results.first!
        shoppingCartProducts = shoppingCart.products?.allObjects as! [ShoppingCartProduct]
      }
      else {
        shoppingCart = ShoppingCart(context: coreDataStack.managedContext)
        shoppingCart.name = cartName
        coreDataStack.saveContext()
      }
    }
    catch let error as NSError {
      print("Error fetching ShoppingCart: \(error), description: \(error.userInfo)!!")
    }
  }
  
  // Save new products in CoreData's ShoppingCart
  func saveToShoppingCartInCoreData(product: Product) {
    
    var isInShoppingCart = false
    
    /*
     Find out if the product is already in the Shopping Cart
     and update its count
     */
    for p in shoppingCartProducts {
      
      if p.id == product.id {
        isInShoppingCart = true
        p.count += 1
        
        break
      }
    }
    
    /*
     If the product is not in the Shopping Cart,
     then create a new one
     */
    if !isInShoppingCart {
      let cartProduct = ShoppingCartProduct(context: coreDataStack.managedContext)
      cartProduct.id = product.id
      cartProduct.name = product.name
      cartProduct.type = product.type
      cartProduct.count = 1
      cartProduct.price = product.price.value
      cartProduct.imgUrl = product.imageUrl
      
      shoppingCart.addToProducts(cartProduct)
      shoppingCartProducts.append(cartProduct)
    }
    
    shoppingCart.productCount += 1
    
    coreDataStack.saveContext()
  }
  
  // Update the ShoppingCart's total price in CoreData
  func updateShoppingCartTotalInCoreData(with amount: Double) {
    
    let currentTotal = shoppingCart.totalAmount
    
    if currentTotal > 0 {
      shoppingCart.totalAmount = currentTotal + amount
    }
    else {
      shoppingCart.totalAmount = amount
    }
    
    coreDataStack.saveContext()
  }

}
