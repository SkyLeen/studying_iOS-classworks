//
//  ExtFormatter.swift
//  myWeather 
//
//  Created by Natalya on 06/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let dateFromatted: DateFormatter = {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "dd.MM.yyyy  HH:mm"
        return dataFormatter
    }()
    
}
