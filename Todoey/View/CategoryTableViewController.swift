//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by khalil.panahi on 29/10/21.
//

import RealmSwift
import UIKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    // a container type to hold returned result from object queries.
    var categories: Results<Category>?

    @IBOutlet weak var addButton: UIBarButtonItem!
    // initilize a new Realm access point
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // to access the cell property of super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let item = categories?[indexPath.row] ?? nil

        cell.textLabel?.text = item?.name ?? "No category added yet"

        if let color = item?.backgroundColor {
            cell.backgroundColor = UIColor(hexString: color)

            //to change text color depending on background color
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
        }
        
        
        return cell
    }

    // MARK: - Data Manipulation Methods

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving : ", error)
        }

        tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    // MARK: - Delete Data fom Swipt

    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemToDelete)
                }
                loadCategories()
            } catch {
                print("Error saving : ", error)
            }
        }
    }

    // MARK: - Add New Item

    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        // adding a textfield into alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }

        let action = UIAlertAction(title: "Add Category", style: .default) { _ in
            // what will happen once the user clicks the add item on UIAlert

            // create an object of Entity
            var newCategory = Category()

            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.randomFlat().hexValue()

            self.save(category: newCategory)
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
