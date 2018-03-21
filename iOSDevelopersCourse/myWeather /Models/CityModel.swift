//
//  CityModel.swift
//  myWeather 
//
//  Created by Natalya on 21/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class City: Object {
    
    @objc dynamic var name: String = ""
    let weather = List<Weather>()
    
    @objc override open class func primaryKey() -> String? {
        return "name"
    }
}
