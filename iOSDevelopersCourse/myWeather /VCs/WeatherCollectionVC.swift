//
//  WeatherCollectionVCCollectionViewController.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherCollectionVC: UICollectionViewController {
    
    var titleVC = ""
    let weatherService = WeatherService()
    private var weather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleVC
        
        weatherService.loadWeatherDataFor5Days(for: titleVC) { [weak self]  in
            self?.loadWeatherData(city: (self?.titleVC)!)
            self?.collectionView?.reloadData()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weather.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherViewCell
        let weather = self.weather[indexPath.row]

        cell.weatherLabel.text = "\(weather.temp) C, \(weather.description)"
        cell.timeLabel.text = cell.dateConfigure(with: weather)
        //cell.iconImage.image = UIImage(named: weather.icon)
        return cell
    }
    
    private func loadWeatherData(city: String) {
        do {
            let realm = try Realm()
            self.weather = Array(realm.objects(Weather.self).filter("city == %@", city))
        } catch {
            print(error.localizedDescription)
        }
    }
}
