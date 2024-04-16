//
//  Product.swift
//  WishListNBC
//
//  Created by David Jang on 4/15/24.
//

import Foundation
import CoreData

// NSManagedObject 서브클래스 생성 xcdatamodeld 파일(화면) > Editor > Create NSManagedObject subclass

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {
    
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var price: Int64
    @NSManaged public var thumbnail: String?
    @NSManaged public var quantity: Int16
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.quantity = 1
    }
}
