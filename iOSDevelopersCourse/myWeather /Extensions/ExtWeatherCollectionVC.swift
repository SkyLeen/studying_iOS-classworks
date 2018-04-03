//
//  ExtWeatherCollectionVC.swift
//  myWeather 
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension WeatherCollectionVC {
    
    func getNotification() {
        self.token = weather.observe { [weak self] changes in
            guard let collection = self?.collectionView else { return }
            switch changes {
            case .initial:
                collection.reloadData()
            case .update(_, let delete, let insert, let update):
                collection.performBatchUpdates ({
                    collection.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    collection.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    collection.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension WeatherCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCount: CGFloat = 2
        let screenWidth = collectionView.bounds.size.width
        let itemWidth = (screenWidth - (interItemSpace * itemsCount))/itemsCount
        
        let cellSize = CGSize(width: itemWidth, height: itemWidth)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
}

