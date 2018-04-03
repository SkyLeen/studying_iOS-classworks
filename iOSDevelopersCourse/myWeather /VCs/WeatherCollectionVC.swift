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
    
    var titleVC: String = ""
    let interItemSpace: CGFloat = 5
    lazy var weather: Results<Weather> = {
      return Loader.loadData(object: Weather())
    }()
    
    var token: NotificationToken?
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleVC
        WeatherService.loadWeatherDataFor5Days(for: titleVC)
        getNotification()
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
        
        let getImage = GetHashImage(url: weather.iconUrl)
        getImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.iconImage.image = getImage.outputImage
            }
        }
        operationQueue.addOperation(getImage)
        
        return cell
    }
}
