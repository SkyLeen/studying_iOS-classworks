//
//  WeatherViewCell.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class WeatherViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    static var dateFormatter: DateFormatter = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd.MM.yyyy  HH.mm"
        return dataFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    func dateConfigure(with weather: Weather) -> String {
        let date = Date(timeIntervalSince1970: weather.dateTime)
        let dateString = WeatherViewCell.dateFormatter.string(from: date)
        return dateString
    }
}
