//
//  WeatherRealmSaving.swift
//  myWeather 
//
//  Created by Natalya on 21/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class Saver {
    
    static func saveWeatherData<T: Object>(objects: [T], filterFor item: String) {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = configuration
        
        do {
            let realm = try Realm(configuration: configuration)
            let oldItem = realm.objects(T.self).filter("city == %@", item)
            try realm.write {
                realm.delete(oldItem)
                realm.add(objects, update: true)
            }
        } catch {
            print(error)
        }
    }
}
