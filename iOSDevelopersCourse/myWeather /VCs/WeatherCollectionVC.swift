//
//  WeatherCollectionVCCollectionViewController.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit

class WeatherCollectionVC: UICollectionViewController {
    
    var titleVC: String = ""
    private let interItemSpace: CGFloat = 5
    
    lazy var weather: Results<Weather> = {
        return Loader.loadData(object: Weather())
    }()
    
    var weatherArray = [Weather]()
    
    private let recordType = "Weather"
    private var cloudDB: CKDatabase = CKContainer.default().publicCloudDatabase
    
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
        WeatherService.loadWeatherDataFor5Days(for: titleVC, closure: {
            CloudSaver.operateDataCloud(weather: Array(self.weather))
        })
        token = AlertHelper.setNotification(to: weather, view: self.collectionView)
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
        
        cell.weather = weather
        
        let getImage = GetCashedImage(url: weather.iconUrl)
        getImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.iconImage.image = getImage.outputImage
            }
        }
        operationQueue.addOperation(getImage)
        
        return cell
    }
}

extension WeatherCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCount: CGFloat = 2
        let screenWidth = collectionView.bounds.size.width
        let itemWidth = (screenWidth - (interItemSpace * itemsCount))/itemsCount
        
        let cellSize = CGSize(width: itemWidth, height: itemWidth)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
}

extension WeatherCollectionVC {
    
    private func loadDataFromCloud() -> [Weather] {
        var weatherArr = [Weather]()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        queryOp.recordFetchedBlock = { (record: CKRecord!) in
            let weatherItem = Weather()
            weatherItem.id = String(describing: record.value(forKey: "id"))
            weatherItem.city = String(describing: record.value(forKey: "city"))
            weatherItem.dateTime = record.value(forKey: "dateTime") as! Double
            weatherItem.icon = String(describing: record.value(forKey: "icon"))
            weatherItem.temp = record.value(forKey: "temp") as! Double
            weatherItem.compoundKey = String(describing: record.value(forKey: "id")) + String(describing: record.value(forKey: "city"))
            weatherArr.append(weatherItem)
        }
        cloudDB.add(queryOp)
        
        return weatherArr
    }
}
