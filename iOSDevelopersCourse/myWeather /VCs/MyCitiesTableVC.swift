//
//  MyCitiesTableVC.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class MyCitiesTableVC: UITableViewController {

    var myCitiesArray = [String]()
    
    lazy var cities: Results<City>? = {
        return Loader.loadData(object: City())
    }()
    
    var token: NotificationToken?
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotification()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let citiesCount = cities!.count
        return citiesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MyCitiesCell", for: indexPath) as! MyCitiesViewCell
        let cities = self.cities![indexPath.row]
         cell.myCityName.text = cities.name
        
         return cell
     }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let city = cities![indexPath.row]
        if editingStyle == .delete {
            deleteCity(city: city)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWeather", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showWeather" else { return }
        guard let destVC = segue.destination as? WeatherCollectionVC else { return }
        guard let title = sender as? IndexPath else { return }
        destVC.titleVC = cities![title.row].name
    }
    
    @IBAction func addCityPressed(_ sender: UIBarButtonItem) {
        showAddCityFrom()
    }
    
    private func getNotification() {
        token = cities?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let delete, let insert, let update):
                tableView.beginUpdates()
                tableView.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            }
        })
    }
    
    private func showAddCityFrom() {
        let alertForm = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        alertForm.addTextField(configurationHandler: {(_ textField: UITextField) -> () in })
        
        let add = UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
            guard let name = alertForm.textFields?[0].text else { return }
            self?.addCity(name: name)
            })
        alertForm.addAction(add)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertForm.addAction(cancel)
        
        present(alertForm, animated: true, completion: nil)
    }
    
    private func addCity(name: String) {
        let city = City()
        city.name = name
        WeatherSaver.saveCities(city: city)
    }
    
    private func deleteCity(city: City) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(city.weather)
                realm.delete(city)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
