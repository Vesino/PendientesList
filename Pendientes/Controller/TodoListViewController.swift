//
//  ViewController.swift
//  Pendientes
//
//  Created by Luis Vargas on 12/4/20.
//  Copyright © 2020 Luis Vargas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //array de Items Objects
    var array = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Preparar café"
        newItem.done = true
        array.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "hacer ejercicio"
        newItem2.done = false
        array.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Aprender Docker"
        newItem3.done = false
        array.append(newItem3)
        
        if let itemsArray = defaults.array(forKey: "TodoListArray") as? [Item] {
            array = itemsArray
        }
        
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
        array[indexPath.row].done = !array[indexPath.row].done
        tableView.reloadData()
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
                let newItemAdded = Item()
                newItemAdded.title = itemAdded
                self.array.append(newItemAdded)
                self.defaults.set(self.array, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Item"
            itemAdeddTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


