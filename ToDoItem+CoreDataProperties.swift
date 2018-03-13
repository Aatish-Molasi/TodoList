//
//  ToDoItem+CoreDataProperties.swift
//  TodoList
//
//  Created by Aatish Molasi on 3/13/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "TodoItem");
    }

    @NSManaged public var details: String?
    @NSManaged public var done: Bool
    @NSManaged public var title: String?

}
