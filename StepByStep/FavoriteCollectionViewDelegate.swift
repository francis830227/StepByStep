//
//  FavoriteCollectionViewDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell",
                                                      for: indexPath) as! FavoriteCollectionViewCell
                
        cell.storeNameLabel.text = places[indexPath.row].name
        
        cell.storeAddressLabel.text = places[indexPath.row].address
        
        cell.storeImageView.image = places[indexPath.row].image
        
        return cell
    }
    
}
