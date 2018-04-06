//
//  ExtDate.swift
//  myWeather 
//
//  Created by Natalya on 06/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        return Formatter.dateFromatted.string(from: self)
    }
}
