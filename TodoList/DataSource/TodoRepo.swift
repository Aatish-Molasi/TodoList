//
//  TodoRepo.swift
//  TodoList
//
//  Created by Aatish Molasi on 3/13/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class TodoRepo {
    static let sharedRepo: TodoRepo = TodoRepo()

    var todoList: [ToDoItem] = []
    var managedContext: NSManagedObjectContext?

    init() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        self.managedContext =
            appDelegate.persistentContainer.viewContext
    }

    func getTodoListDone(done: Bool) -> [ToDoItem] {
        var result:[ToDoItem] = []
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
        fetchRequest.predicate = NSPredicate(format: "done == %@", NSNumber(value: done))

        do {
            result = try managedContext?.fetch(fetchRequest) as! [ToDoItem]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result.reversed()
    }
    
    func getTodoItem(id: Int) -> ToDoItem? {
        return nil
    }

    func addTodoItem(text: String) {
        let entity =
            NSEntityDescription.entity(forEntityName: "ToDoItem",
                                       in: self.managedContext!)!

        let todoItem = NSManagedObject(entity: entity,
                                     insertInto: managedContext)

        todoItem.setValue(text, forKeyPath: "details")
        todoItem.setValue(false, forKeyPath: "done")

        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func updateTodoItem(item: ToDoItem) {
        let item = self.managedContext?.object(with: item.objectID) as! ToDoItem
        item.setValue(item.details, forKey: "details")
        item.setValue(item.done, forKey: "done")
        item.setValue(item.title, forKey: "title")
        do {
            try managedContext?.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func removeTodoItem(item: ToDoItem) {
        let item = self.managedContext?.object(with: item.objectID) as! ToDoItem
        self.managedContext?.delete(item)
    }
}
