//
//  ExtWeatherViewCell.swift
//  myWeather 
//
//  Created by Natalya on 06/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension WeatherViewCell {
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.bounds.width - insets * 2
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(width), height: ceil(height))
        
        return labelSize
    }
    
    func setWeartherLabelSize() {
        let weatherLabelSize = getLabelSize(text: weatherLabel.text!, font: weatherLabel.font)
        
        let positionX = (self.bounds.width - weatherLabelSize.width) / 2
        let labelOrigin = CGPoint(x: positionX, y: insets)
        
        let rect = CGRect(origin: labelOrigin, size: weatherLabelSize)
        weatherLabel.frame = rect
    }
    
    func setTimeLabelSize() {
        let timeLabelSize = getLabelSize(text: timeLabel.text!, font: timeLabel.font)
        
        let positionX = (self.bounds.width - timeLabelSize.width) / 2
        let positionY = self.bounds.height - insets - timeLabelSize.height
        let labelOrigin = CGPoint(x: positionX, y: positionY)
        
        let rect = CGRect(origin: labelOrigin, size: timeLabelSize)
        timeLabel.frame = rect
    }
    
    func setIconImage() {
        let side: CGFloat = self.bounds.height - timeLabel.bounds.height - weatherLabel.bounds.height - insets * 2
        let iconSize = CGSize(width: side, height: side)
    
        let positionX = (self.bounds.midX - side / 2)
        let positionY = (self.bounds.midY - side / 2)
        let origin = CGPoint(x: positionX, y: positionY)
        
        let rect = CGRect(origin: origin, size: iconSize)
        iconImage.frame = rect
    }
    
}
