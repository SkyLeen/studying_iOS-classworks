//
//  WeatherCollectionVCCollectionViewController.swift
//  myWeather 
//
//  Created by Natalya on 23/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class WeatherCollectionVC: UICollectionViewController {
    
    var titleVC = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleVC
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherViewCell
        
        cell.weatherLabel.text = "- 15 C"
        cell.timeLabel.text = "24.02.2018 00:20"
    
        return cell
    }

}
