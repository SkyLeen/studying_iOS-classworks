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

    convenience init(json: JSON) {
        self.init()
        id = json["dt"].stringValue
        dateTime = json["dt"].doubleValue
        temp = json["main"]["temp"].doubleValue
        icon = json["weather"][0]["icon"].stringValue
        weatherDescription = json["weather"][0]["main"].stringValue
    }
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
}
