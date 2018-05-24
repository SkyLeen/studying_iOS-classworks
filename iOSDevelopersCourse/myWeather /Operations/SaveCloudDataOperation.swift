//
//  SaveCloudDataOperation.swift
//  myWeather 
//
//  Created by Natalya on 24/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import CloudKit

class SaveData: CKDatabaseOperation {
    
    private let weather: [Weather]
    private var cloudDB: CKDatabase = CKContainer.default().publicCloudDatabase
    private let recordType = "Weather"
    
    init(weather: [Weather]) {
        self.weather = weather
    }
    
    override func main() {

            for item in self.weather {
                let recordId = CKRecordID(recordName: "\(item.compoundKey)")
                let record = CKRecord(recordType: self.recordType , recordID: recordId)
                record.setValue("\(item.city)", forKey: "city")
                record.setValue(item.dateTime, forKey: "dateTime")
                record.setValue("\(item.icon)", forKey: "icon")
                record.setValue("\(item.id)", forKey: "id")
                record.setValue(item.temp, forKey: "temp")
                record.setValue("\(item.weatherDescription)", forKey: "weatherDescription")
                
                self.cloudDB.save(record) { (record, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
    }
}
