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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        
        loadItems()
        
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
        
        self.saveItem()
        
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
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let newItemAdded = Item(context: <#T##NSManagedObjectContext#>)
                newItemAdded.title = itemAdded
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(array)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encodign item Array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                array = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
            
        }
    }
}


