//
//  ViewController.swift
//  Todoey
//
//  Created by Khalil panahi
//

import ChameleonFramework
import RealmSwift
import UIKit

class TodoListViewController: SwipeTableViewController {
    var todoItems: Results<Todo>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchBar.delegate = self

        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory!.backgroundColor)
        title = selectedCategory?.name
        
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory!.backgroundColor)!, returnFlat: true)
        
        searchBar.barTintColor = UIColor(hexString: selectedCategory!.backgroundColor)
        
        
    }

    // MARK: - DATASOURCE

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title

            // to add and remove selected mark after selecting a row
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        //to change text and background color
        if let color = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage:
            CGFloat(indexPath.row) / CGFloat(todoItems!.count)
            ) {
            cell.backgroundColor = color
            
            //to change text color depending on background color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }

        return cell
    }

    // MARK: TebleView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // to delete the item from table
//                    realm.delete(item)

                    // to update the object in table
                    item.done = !item.done
                }
            } catch {
                print("Error on updating done : ", error)
            }
        }

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - ADD NEW ITEM

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            // what will happen once the user clicks the add item on UIAlert

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        var newTodo = Todo()
                        newTodo.title = textField.text!
                        newTodo.dateCreated = Date()
                        currentCategory.todos.append(newTodo)
                    }
                } catch {
                    print("Error on saving Todo : ", error)
                }
            }

            self.tableView.reloadData()
        }

        func save(todo: Todo) {
            do {
                try realm.write {
                    realm.add(todo)
                }
            } catch {
                print("Error saving context : ", error)
            }

            tableView.reloadData()
        }

        // adding a textfield into alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Delete Data fom Swipt

    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemToDelete)
                }
                loadItems()
            } catch {
                print("Error deleting item : ", error)
            }
        }
    }

    func loadItems() {
        todoItems = selectedCategory?.todos.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        to load all items when searchbar does not have any text
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
//                to hide keyboard when clear the search bar
                searchBar.resignFirstResponder()
            }
        }
    }
}
