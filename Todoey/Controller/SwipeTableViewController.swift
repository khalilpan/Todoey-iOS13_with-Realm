//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by khalil.panahi 
//

import SwipeCellKit
import UIKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Table view data source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
            // handle action by updating model with deletion

            // to delete the selected item
            self.updateModel(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }

    func updateModel(at indexPath: IndexPath) {
        // update our data model
        // will be ovverriden in the child classes

        print("Selected item will be deleted.")
    }
}
