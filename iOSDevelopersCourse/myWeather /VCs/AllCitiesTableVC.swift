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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countriesArray[section]
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
}
