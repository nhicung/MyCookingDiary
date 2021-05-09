//
//  FavoriteTableViewController.swift
//  MyCookingDiary
//
//  Created by Nhi Cung on 5/3/21.
//  Copyright © 2021 Nhi Cung. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {

    var recipes:[NSManagedObject] = []
    var favoriteList:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDataFromDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        do {
            recipes = try context.fetch(request)
            favoriteList = []
            for recipe in recipes {
                let r = recipe as! Recipe
                if r.favorite == true {
                    favoriteList.append(r)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritesTableViewCell
        
        // Configure the cell...
        let recipe = favoriteList[indexPath.row] as? Recipe
            cell.faveTitle.text = recipe?.recipeName
            cell.rateFav.text = String (format: "%.1f", recipe!.rate)
            let image = recipe?.image
            //        image = jpegData(compressionQuality: 0.9)
            if image != nil{
                //            cell.recipeImg.contentMode = .scaleAspectFit
                cell.favImage.image = UIImage(data: image!)
            }
//        } else {
//            cell.isHidden = true
//        }
//       cell.accessoryType = UITableViewCell.AccessoryType .detailDisclosureButton
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Edit Favorite" {
            let recipeController = segue.destination as? AddRecipeViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedRecipe = recipes[selectedRow!] as? Recipe
            recipeController?.currentRecipe = selectedRecipe!
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            let recipe = recipes[indexPath.row] as? Recipe
//            let context = appDelegate.persistentContainer.viewContext
//            context.delete(recipe!)
//            do {
//                try context.save()
//            } catch {
//                fatalError("Error saving context: \(error)")
//            }
//            loadDataFromDatabase()
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedRecipe = recipes[indexPath.row] as? Recipe
        let name = selectedRecipe!.recipeName!
        let actionHandler = { (actions:UIAlertAction!) -> Void in self.performSegue(withIdentifier: "Edit Favorite", sender: tableView.cellForRow(at: indexPath))
        }
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "RecipeController") as? AddRecipeViewController
        //        controller?.currentRecipe = selectedRecipe
        //        self.navigationController?.pushViewController(controller!, animated: true)
        
        let alertController = UIAlertController(title: "Recipe selected", message: "Selected row: \(indexPath.row) (\(name))", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }


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

}
