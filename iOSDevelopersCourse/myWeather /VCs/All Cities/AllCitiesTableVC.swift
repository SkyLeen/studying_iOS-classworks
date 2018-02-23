//
//  FavoritiesTableVC.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllCitiesTableVC: UITableViewController {
    var countriesArray = ["Russia"]
    var citiesArray = ["Moscow","London","Paris","New York","Tokyo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsCount = countriesArray.count
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = citiesArray.count
        return rowsCount
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCitiesCell", for: indexPath) as! AllCitiesViewCell
        cell.cityName.text = citiesArray[indexPath.row]
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
 
//    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "addNewItem", sender: nil)
//    }
    



    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
