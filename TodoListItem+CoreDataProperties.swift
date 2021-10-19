//
//  TodoListItem+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Akanksha pakhale on 18/10/21.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension TodoListItem : Identifiable {

}
