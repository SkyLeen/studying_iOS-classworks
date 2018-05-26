//
//  TodayViewController.swift
//  myWeatherWidget
//
//  Created by Natalya on 26/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherService.loadWeatherDataFor5Days(for: "Moscow", closure: { weather in
            guard let weather = weather.first else {
                self.tempLabel.text = "No data"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
