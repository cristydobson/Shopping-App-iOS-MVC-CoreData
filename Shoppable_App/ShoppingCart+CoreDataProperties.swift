//
//  ShoppingCart+CoreDataProperties.swift
//
//  Created by Cristina Dobson 
//
//

import Foundation
import CoreData


extension ShoppingCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCart> {
        return NSFetchRequest<ShoppingCart>(entityName: "ShoppingCart")
    }

    @NSManaged public var name: String?
    @NSManaged public var totalAmount: Double
    @NSManaged public var productCount: Int64
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension ShoppingCart {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ShoppingCartProduct)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ShoppingCartProduct)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension ShoppingCart : Identifiable {

}
