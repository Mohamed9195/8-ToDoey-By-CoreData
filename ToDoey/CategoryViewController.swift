//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by mohamed hashem on 10/31/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class CategoryViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    var path = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound ]) { (didAllow, error) in }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let longPressgester = UILongPressGestureRecognizer(target: self, action: #selector(editCategory))
        tableView.addGestureRecognizer(longPressgester)
        
// to save photo create it by binary and convert to bynary befor save
       //let imageData = weatherIcon.image!.pngData()
        
        loadItems()
        
    }

 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textCell = UITextField()
        let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textCell.text! != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textCell.text!
                self.categoryArray.append(newCategory)
                self.saveCategory()
               
            }
            
        }))
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "Creat new Category"; textCell = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return categoryArray.count
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodocategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
            return cell
        }
    
    
    
    
    
// MARK: - Table view data delegate
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     tableView.deselectRow(at: indexPath, animated: true)
    path = Int(indexPath.row)
    performSegue(withIdentifier: "goToItems", sender: self)
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.selectedCategory = categoryArray[path]
       
    }
    
    
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            saveCategory()
        }else if editingStyle == .insert {
            
    }
    }
    
    
    
    
    
    
// MARK: - Table view Mainpulation
    
    // save category
    func saveCategory() {
        do{
            try context.save()
            
        }catch{
            
            print("Error in saving data: \(error)")
        }
        tableView.reloadData()
    }
    
    // reade category
    func loadItems(With request: NSFetchRequest<Category> = Category.fetchRequest())  {
        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            
            print("Error in reading data : \(error)")
        }
         tableView.reloadData()
    }
    
    
    @objc func editCategory(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexpath = tableView.indexPathForRow(at: touchPoint) {
                
                var textcell = UITextField()
                let alert = UIAlertController(title: "Edit caegory", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    
                    if textcell.text! != "" {
                        
                        self.categoryArray[indexpath.row].name! = textcell.text!
                        self.saveCategory()
                    }
                    
                }))
                
                alert.addTextField { (alertTextField) in alertTextField.placeholder = self.categoryArray[indexpath.row].name! ; textcell = alertTextField
                }
                
                present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    
    
    
}















/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */


/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
