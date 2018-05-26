//
//  TodayViewController.swift
//  myWeatherWidget
//
//  Created by Natalya on 26/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pages: UIPageControl!
    

    lazy var cities: Results<City>! = {
        return Loader.loadData(object: City())
    }()
    private var counter: Int = 0
    private var count = 0
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRealm()
        configurePageControl()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func changePages(_ sender: UIPageControl) {
        if counter >= count {
            counter = 0
        }
        
        pages.currentPage = counter
        loadWeather(for: cities[counter].name)
        counter = counter + 1
    }
    
    private func loadWeather(for city: String) {
        WeatherService.loadWeatherDataFor5Days(for: city, closure: { weather in
            guard let weather = weather.first else {
                self.tempLabel.text = ""
                self.descriptionLabel.text = ""
                self.cityLabel.text = "No data"
                return
            }
            self.cityLabel.text = weather.city
            self.descriptionLabel.text = weather.weatherDescription
            self.tempLabel.text = "\(weather.temp) C"
            
            let getImage = GetCashedImage(url: weather.iconUrl)
            getImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.imageLabel.image = getImage.outputImage
                }
            }
            self.operationQueue.addOperation(getImage)
        })
    }
    
    private func configurePageControl() {
        count = cities.count
        pages.numberOfPages = count
        pages.currentPage = 0
        pages.tintColor = UIColor.red
        pages.pageIndicatorTintColor = UIColor.black
        pages.currentPageIndicatorTintColor = UIColor.green
        loadWeather(for: cities[0].name)
        counter = counter + 1
    }
    
    private func configureRealm() {
        let configuration = Realm.Configuration(
            fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.myWeatherGroup")?.appendingPathComponent("default.realm"),
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [Weather.self, City.self])
        Realm.Configuration.defaultConfiguration = configuration
    }
    
}
