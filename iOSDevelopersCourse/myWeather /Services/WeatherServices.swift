//
//  WeatherServices.swift
//  myWeather 
//
//  Created by Natalya on 02/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    let baseUrl = "http://api.openweathermap.org"
    let appId = "cb13ebbbd6b51fb8e8b4110648fc195f"
    
    var sessionManager = SessionManager()
    
    func loadWeatherDataFor5Days(for city: String){
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
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
