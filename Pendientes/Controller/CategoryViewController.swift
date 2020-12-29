//
//  CategoryViewController.swift
//  Pendientes
//
//  Created by Luis Vargas on 12/17/20.
//  Copyright © 2020 Luis Vargas. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray = [Category]()
    
    //here we applied singleton principle
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryAdeddTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add a new category", style: .default) { (action) in
            
            //Aqui pasara cuando el usuario de click en añadir categoria
            let categoriaAdded = categoryAdeddTextField.text!
            
            if categoriaAdded == "" {
                let alerta = UIAlertController(title: "Debes de escribir una categoria intentalo de nuevo", message: "", preferredStyle: .alert)
                let accion = UIAlertAction(title: "OK", style: .default) { (_) in
                    return
                }
                alerta.addAction(accion)
                self.present(alerta, animated: true, completion: nil)
            } else {
                let newCategory = Category(context: self.context)
                newCategory.name = categoriaAdded
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            categoryAdeddTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("There was an error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func updateModelDeleted(at: IndexPath) {
        let categoryForDeletion = self.categoryArray[at.row]
        self.context.delete(categoryForDeletion)
        self.saveCategory()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
    
}

