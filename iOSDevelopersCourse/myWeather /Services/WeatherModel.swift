//
//  WeatherModel.swift
//  myWeather 
//
//  Created by Natalya on 08/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Weather {
    var dateTime: Double = 0.0
    var temp: Double = 0.0
    var description: String = ""
    var icon: String = ""

    init(json: JSON) {
        self.dateTime = json["dt"].doubleValue
        self.temp = json["main"]["temp"].doubleValue
        self.icon = json["weather"][0]["icon"].stringValue
        self.description = json["weather"][0]["main"].stringValue
    }
}
