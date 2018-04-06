//
//  Functions.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

struct AlertHelper {
    
    func showAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(actionButton)
        
        return alertController
    }
    
    static func setNotification<T: Object>(to array: Results<T>, view: UICollectionView?) -> NotificationToken {
        let token = array.observe { [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.performBatchUpdates ({
                    view.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    view.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    view.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        return token
    }
}
