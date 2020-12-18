//
//  ViewController.swift
//  Pendientes
//
//  Created by Luis Vargas on 12/4/20.
//  Copyright © 2020 Luis Vargas. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //array de Items Objects
    var array = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    ////MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = array[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    ////MARK: - Delegate functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //removing
        
        //context.delete(array[indexPath.row])
        //array.remove(at: indexPath.row)
        
        array[indexPath.row].done = !array[indexPath.row].done
        
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ////MARK: - Add new items
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var itemAdeddTextField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new Item", style: .default) { (action) in
            // Que pasara cuando el usuario de click en añadir un nuevo item
            
            let itemAdded = itemAdeddTextField.text!
            
            if itemAdded == "" {
                let alerta = UIAlertController(title: "Debes de escribir un pendiente", message: "", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .default) { (_) in
                    return
                }
                alerta.addAction(accion)
                self.present(alerta, animated: true, completion: nil)
            } else {
                
                let newItemAdded = Item(context: self.context)
                newItemAdded.title = itemAdded
                newItemAdded.done = false
                newItemAdded.parentCategory = self.selectedCategory
                self.array.append(newItemAdded)
                
                self.saveItem()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Item"
            itemAdeddTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print("Error saving, contex \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //We need to specifi the type of the output
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            array = try context.fetch(request)
        } catch {
            print("There was an error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}


//MARK: - SearchBar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //String comparisons are by default case and diacritic sensitive. we avoid this behaivior with CONTAINS[cd]
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


