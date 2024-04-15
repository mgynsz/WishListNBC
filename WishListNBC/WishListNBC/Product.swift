//
//  Product.swift
//  WishListNBC
//
//  Created by David Jang on 4/15/24.
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {
    
    @NSManaged public var title: String
    @NSManaged public var productDescription: String
    @NSManaged public var price: Int64
    @NSManaged public var thumbnail: String?
    @NSManaged public var quantity: Int16
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.quantity = 1
    }
}
