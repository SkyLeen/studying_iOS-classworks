//
//  WeatherRealmLoading.swift
//  myWeather 
//
//  Created by Natalya on 21/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class Loader {
    
    static func loadWeatherData<T: Object>(object: T) -> Results<T> {
        var resault: Results<T>?
        do {
            let realm = try Realm()
            resault = realm.objects(T.self)
        } catch {
            print(error.localizedDescription)
        }
        return resault!
    }
}
