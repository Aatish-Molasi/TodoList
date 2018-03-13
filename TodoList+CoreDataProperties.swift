//
//  TodoList+CoreDataProperties.swift
//  TodoList
//
//  Created by Aatish Molasi on 3/13/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList");
    }

    @NSManaged public var todoItems: NSObject?

}
