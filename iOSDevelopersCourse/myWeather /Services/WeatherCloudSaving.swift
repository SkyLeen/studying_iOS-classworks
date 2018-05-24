//
//  WeatherCloudSaving.swift
//  myWeather 
//
//  Created by Natalya on 24/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import CloudKit

class CloudSaver {
    
    static private let recordType = "Weather"
    static private var recordIDsToDelete = [CKRecordID]()
    static private var cloudDB: CKDatabase = CKContainer.default().publicCloudDatabase
    
    static func operateDataCloud(weather: [Weather]) {
        
        let operation = CKModifyRecordsOperation()
        
        let predicate = NSPredicate(value: true)
        let queryDel = CKQuery(recordType: recordType, predicate: predicate)
        let queryOpDel = CKQueryOperation(query: queryDel)
        queryOpDel.recordFetchedBlock = { (record: CKRecord!) in
            self.recordIDsToDelete.append(record.recordID)
        }
        
        queryOpDel.queryCompletionBlock = { (cursor: CKQueryCursor?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                operation.recordIDsToDelete = self.recordIDsToDelete
                
                operation.modifyRecordsCompletionBlock = { (savedRecords: [CKRecord]?, deletedRecordIDs: [CKRecordID]?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.saveDataToCloud(weather: weather)
                        }
                    }
                }
                self.cloudDB.add(operation)
            }
        }
        cloudDB.add(queryOpDel)
    }
    
    static private func saveDataToCloud(weather: [Weather]) {
        for item in weather {
            let recordId = CKRecordID(recordName: "\(item.compoundKey)")
            let record = CKRecord(recordType: self.recordType , recordID: recordId)
            record.setValue("\(item.city)", forKey: "city")
            record.setValue(item.dateTime, forKey: "dateTime")
            record.setValue("\(item.icon)", forKey: "icon")
            record.setValue("\(item.id)", forKey: "id")
            record.setValue(item.temp, forKey: "temp")
            record.setValue("\(item.weatherDescription)", forKey: "weatherDescription")
            
            cloudDB.save(record) { (record, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
