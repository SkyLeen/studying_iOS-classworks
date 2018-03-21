//
//  WeatherServices.swift
//  myWeather 
//
//  Created by Natalya on 02/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

class WeatherService {
    static let baseUrl = "http://api.openweathermap.org"
    static let appId = "cb13ebbbd6b51fb8e8b4110648fc195f"
    
    static var sessionManager = SessionManager()
    
    static func loadWeatherDataFor5Days(for city: String){
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
                Saver.saveWeatherData(objects: weather)
            case .failure(let error):
                print(error)
            }
        }
    }
    
   
}
