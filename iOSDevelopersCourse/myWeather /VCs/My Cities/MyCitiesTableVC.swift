//
//  MyCitiesTableVC.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyCitiesTableVC: UITableViewController {

    var myCitiesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let citiesCount = myCitiesArray.count
        return citiesCount
    }
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MyCitiesCell", for: indexPath) as! MyCitiesViewCell
        
         cell.myCityName.text = myCitiesArray[indexPath.row]
        
         return cell
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myCitiesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWeather", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showWeather" else { return }
        guard let destVC = segue.destination as? WeatherCollectionVC else { return }
        guard let title = sender as? IndexPath else { return }
        destVC.titleVC = myCitiesArray[title.row]
    }
    
    @IBAction func addCityPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAllCities", sender: nil)
    }
    
    @IBAction func addCity(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewCity" else { return }
        guard let allCitiesVC = segue.source as? AllCitiesTableVC else { return }
        guard let cellNewCity = allCitiesVC.tableView.indexPathForSelectedRow else { return }
        
        let newCity = allCitiesVC.citiesArray[cellNewCity.row]
        
        guard !myCitiesArray.contains(newCity) else {
            present(Functions().showAlert(withTitle: "Warning!", message: "There is a such City in the list"), animated: false)
            return
        }
        myCitiesArray.append(newCity)
        tableView.reloadData()
    }
}
