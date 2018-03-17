//
//  WeatherModel.swift
//  myWeather 
//
//  Created by Natalya on 08/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Weather: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var dateTime: Double = 0.0
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var icon: String = ""
    @objc dynamic var city: String = ""

    convenience init(json: JSON, city: String) {
        self.init()
        
        self.id = json["dt"].stringValue
        self.dateTime = json["dt"].doubleValue
        self.temp = json["main"]["temp"].doubleValue
        self.icon = json["weather"][0]["icon"].stringValue
        self.weatherDescription = json["weather"][0]["main"].stringValue
        self.city = city
    }
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
}
