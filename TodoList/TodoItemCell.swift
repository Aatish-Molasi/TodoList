//
//  TodoItemCell.swift
//  TodoList
//
//  Created by Aatish Molasi on 3/13/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import UIKit

protocol ToDoCellDelegate {
    func updatedItem(item: ToDoItem?)
    func updateTableHeight()
    func reloadData()
}

class TodoItemCell: UITableViewCell {
    @IBOutlet var itemDescription: UITextView!
    @IBOutlet var checkMarkImageView: UIImageView!
    @IBOutlet var textViewHeight: NSLayoutConstraint!

    var currentItem: ToDoItem?

    var todoCellDelegate: ToDoCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TodoItemCell.getReuseIdentifier())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleSavedState))
        self.checkMarkImageView.addGestureRecognizer(tapGestureRecognizer)
        self.checkMarkImageView.layer.borderColor = UIColor.gray.cgColor
        self.checkMarkImageView.layer.borderWidth = 2
        self.checkMarkImageView.layer.cornerRadius = 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func updateData(item: ToDoItem) {
        self.itemDescription?.delegate = self
        self.currentItem = item
        if item.done {
            self.checkMarkImageView?.image = UIImage(named: "filterCheck")
        } else {
            self.checkMarkImageView?.image = nil
        }
        self.itemDescription?.text = item.details
        self.textViewHeight?.constant = max(40, self.itemDescription.contentSize.height)
//        self.todoCellDelegate?.updateTableHeight()
    }

    static func getReuseIdentifier() -> String {
        return String(describing: TodoItemCell.self)
    }

    func toggleSavedState(sender: AnyObject) {
        self.currentItem?.done = !self.currentItem!.done
        self.todoCellDelegate?.updatedItem(item: self.currentItem)
        self.todoCellDelegate?.reloadData()
    }

    func updateTextViewHeight() {
        self.textViewHeight?.constant = max(40, self.itemDescription.contentSize.height)

        let startHeight = self.itemDescription.frame.size.height
        let calcHeight = self.itemDescription.sizeThatFits(self.itemDescription.frame.size).height

        if startHeight != calcHeight {
            self.todoCellDelegate?.updateTableHeight()
        }
    }
}

extension TodoItemCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newString = String()
        if (range.length == 1 && text.characters.count == 0) {
            newString = String(textView.text.characters.dropLast())
        } else {
            newString = String(textView.text + text)
        }
        self.currentItem?.details = newString
        self.todoCellDelegate?.updatedItem(item: self.currentItem)
        self.updateTextViewHeight()
        return true
    }
}
