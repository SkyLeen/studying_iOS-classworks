//
//  WeatherRealmSaving.swift
//  myWeather 
//
//  Created by Natalya on 21/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class WeatherSaver {
    
    static func saveCities(city: City) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(city, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    static func saveWeatherData (weather: [Weather], for city: String) {
        do {
            let realm = try Realm()
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            let oldWeather = city.weather
            try realm.write {
               realm.delete(oldWeather)
               city.weather.append(objectsIn: weather)
            }
        } catch {
            print(error)
        }
    }
}
