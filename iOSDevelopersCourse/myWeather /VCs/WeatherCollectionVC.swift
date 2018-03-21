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
    private lazy var weather: Results<Weather> = {
      return Loader.loadWeatherData(object: Weather())
    }()
    
    private var token: NotificationToken?
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleVC
        
        WeatherService.loadWeatherDataFor5Days(for: titleVC)
        
        token = weather.observe { [weak self] changes in
            guard let collection = self?.collectionView else { return }
            switch changes {
            case .initial:
                collection.reloadData()
            case .update(_, let delete, let insert, let update):
                collection.performBatchUpdates ({
                    collection.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    collection.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    collection.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
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

        cell.weatherLabel.text = "\(weather.temp) C, " + weather.weatherDescription
        cell.timeLabel.text = cell.dateConfigure(with: weather)
        //cell.iconImage.image = UIImage(named: weather.icon)
        return cell
    }
}
