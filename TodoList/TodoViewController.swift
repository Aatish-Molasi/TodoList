//
//  ViewController.swift
//  TodoList
//
//  Created by Aatish Molasi on 3/13/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UIViewController {

    var todoItems: [ToDoItem] = []
    var todoItemsDone: [ToDoItem] = []

    @IBOutlet var todoListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoItems = TodoRepo.sharedRepo.getTodoListDone(done: false)
        self.todoItemsDone = TodoRepo.sharedRepo.getTodoListDone(done: true)

        self.todoListTableView.allowsSelection = false
        self.todoListTableView.tableFooterView = UIView()

        self.todoListTableView.estimatedRowHeight = 40
        self.todoListTableView.separatorStyle = UITableViewCellSeparatorStyle.none


        let addButton = UIButton(type: UIButtonType.custom)
        addButton.addTarget(self, action: #selector(self.didPressAddButton), for: UIControlEvents.touchUpInside)
        addButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        addButton.setTitle(NSLocalizedString("Add", comment: ""), for: UIControlState())
        addButton.sizeToFit()

        let addBarButton:UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem  = addBarButton

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            /*This is hack where we're loading the tableview twice at launch so that the cell's are reloaded and we get the dynamic size cells once their width is set*/
            self.todoListTableView.reloadData()
        })
        self.todoListTableView.reloadData()
        CATransaction.commit()
    }


    func didPressAddButton() {
        TodoRepo.sharedRepo.addTodoItem(text: "")
        self.updateData()
    }

    func updateData() {
        self.todoItems = TodoRepo.sharedRepo.getTodoListDone(done: false)
        self.todoItemsDone = TodoRepo.sharedRepo.getTodoListDone(done: true)

        let range = NSMakeRange(0, self.todoListTableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.todoListTableView.reloadSections(sections as IndexSet, with: .automatic)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Todo"
        } else if section == 1 {
            return "Done"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todoItems.count
        } else if section == 1 {
            return self.todoItemsDone.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ToDoItem?
        if indexPath.section == 0 {
            item = self.todoItems[indexPath.row]
        } else if indexPath.section == 1 {
            item = self.todoItemsDone[indexPath.row]
        }
        if let cell =
            tableView.dequeueReusableCell(withIdentifier: TodoItemCell.getReuseIdentifier(),
                                          for: indexPath) as? TodoItemCell {
            cell.updateData(item: item!)
            cell.todoCellDelegate = self
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            var item: ToDoItem? = nil
            if indexPath.section == 0 {
                item = self.todoItems[indexPath.row]
            } else if indexPath.section == 1 {
                item = self.todoItemsDone[indexPath.row]
            }
            if item != nil {
                TodoRepo.sharedRepo.removeTodoItem(item: item!)
                self.reloadData()
            }
        }
    }
}

extension TodoViewController: ToDoCellDelegate {
    func updatedItem(item: ToDoItem?) {
        TodoRepo.sharedRepo.updateTodoItem(item: item!)
    }

    func reloadData() {
        self.updateData()
    }

    func updateTableHeight() {
        DispatchQueue.main.async {
            self.todoListTableView.beginUpdates()
            self.todoListTableView.endUpdates()
        }
    }
}
