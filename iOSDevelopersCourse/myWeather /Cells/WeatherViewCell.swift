//
//  WeatherViewCell.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class WeatherViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherLabel: UILabel! {
        didSet {
            weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var iconImage: UIImageView! {
        didSet {
            iconImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var weather: Weather? {
        didSet {
            guard let weather = self.weather else { return }
            weatherLabel.text = "\(weather.temp) C, " + weather.weatherDescription
            timeLabel.text = Date(timeIntervalSince1970: weather.dateTime).formatted
            
            setWeartherLabelSize()
            setTimeLabelSize()
        }
    }
    
    let insets: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setWeartherLabelSize()
        setTimeLabelSize()
        setIconImage()
    }
}
