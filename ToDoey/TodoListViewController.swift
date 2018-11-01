//
//  ViewController.swift
//  ToDoey
//
//  Created by mohamed hashem on 10/28/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    
     var  itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            print("\(selectedCategory)  ooooooooo")
            loadItems()
        }
    }
    
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.editCell))
        tableView.addGestureRecognizer(longpress)

   
   
    }
    
    
    
    
    
    
    //MARK: - TableView DataSourc Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let Cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
       Cell.textLabel?.text = itemArray[indexPath.row].tilte
        
        Cell.accessoryType  = itemArray[indexPath.row].done ?  .checkmark : .none
        
        return Cell
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    override   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // itemArray[indexPath.row].setValue("Completed", forKey: "tilte")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
   
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveItem()
            
        }
    }
    
    
    
    
    
    
    
    //MARK: - Add new item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
           
               // alert.textFields?.first?.text
                
        if textField.text! != "" {
                
                let newItem = Item(context: self.context)
                newItem.tilte = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
            
            
                self.itemArray.append(newItem)
                self.saveItem()
        }
            
            }))
        
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "Creat new item"; textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //MARK: - save data
    func saveItem() {
      
        do{
           try  context.save()
        }catch{
            print("Error saving context \(error)")
        }
          self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    //MARK: - read data
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil) {
        
        let categorypredicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalpredicat = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate , additionalpredicat])
        }else {
            request.predicate = categorypredicate
        }

        
        do{
            itemArray =   try context.fetch(request)
          }catch{
            print("Error in fetch data \(error)")
         }
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    //MARK: - edite cell when long press
    @objc func editCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended{
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                var textField = UITextField()
                
                let alert = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    
                    if textField.text! != "" {
                        self.itemArray[indexPath.row].tilte! = textField.text!
                        self.saveItem()
                    }
                    
                }))
                
                alert.addTextField { (alertTextField) in alertTextField.placeholder = self.itemArray[indexPath.row].tilte! ; textField = alertTextField
                }
                
                present(alert, animated: true, completion: nil)
            }
        }
   

    }
    
    
  
    
    
    
}

//MARK: - Search function

extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "tilte CONTAINS[cd] %@ ", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "tilte", ascending: true)]
        
        loadItems(with: request , predicate: predicate)
        

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
