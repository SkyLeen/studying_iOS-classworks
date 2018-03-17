//
//  WeatherServices.swift
//  myWeather 
//
//  Created by Natalya on 02/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class WeatherService {
    let baseUrl = "http://api.openweathermap.org"
    let appId = "cb13ebbbd6b51fb8e8b4110648fc195f"
    
    var sessionManager = SessionManager()
    
    func loadWeatherDataFor5Days(for city: String, completion: @escaping () -> ()){
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q":city,
            "appid":appId,
            "units":"metric"
        ]
        let url = baseUrl+path
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
       
        sessionManager = SessionManager(configuration: configuration)
        sessionManager.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let weather = JSON(value)["list"].flatMap( { Weather(json: $0.1, city: city) } )
                self.saveWeatherData(weather: weather, city: city)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveWeatherData(weather: [Weather], city: String) {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        do {
            let realm = try Realm(configuration: configuration)
            let oldWeather = realm.objects(Weather.self).filter("city == %@", city)
            print(realm.configuration.fileURL ?? "no file")
            try realm.write {
                realm.delete(oldWeather)
                realm.add(weather, update: true)
            }
        } catch {
            print(error)
        }
    }
}
