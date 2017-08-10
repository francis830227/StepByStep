//
//  FavoriteCollectionViewDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesInfo.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavTableViewCell
        
        cell.storeImageView.image = nil
        
        cell.storeNameLabel.text = placesInfo[indexPath.row].placeName
        
        cell.storeAddressLabel.text = placesInfo[indexPath.row].placeAddress
        
        cell.storeImageView.sd_setShowActivityIndicatorView(true)
        cell.storeImageView.sd_setIndicatorStyle(.white)
        cell.storeImageView.sd_setImage(with: URL(string: placesInfo[indexPath.row].placeImageURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {

            placesInfo.remove(at: indexPath.row)
        }
    }
    
}

