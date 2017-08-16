//
//  PickGooglePhotoTableViewDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/16.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Firebase

extension PickGooglePhotoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickphotoCell", for: indexPath) as! PickGooglePhotoTableViewCell
        
        cell.pickImageView.image = nil
        
        cell.pickLabel.text = placesInfo[indexPath.row].placeName
        
        cell.pickImageView.sd_setShowActivityIndicatorView(true)
        cell.pickImageView.sd_setIndicatorStyle(.white)
        cell.pickImageView.sd_setImage(with: URL(string: placesInfo[indexPath.row].placeImageURL), completed: nil)
        
        return cell
    }
    
}
