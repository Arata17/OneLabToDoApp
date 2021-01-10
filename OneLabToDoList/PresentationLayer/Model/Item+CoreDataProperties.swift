//
//  Item+CoreDataProperties.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/10/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parentCategory: Category?

}

extension Item : Identifiable {

}
