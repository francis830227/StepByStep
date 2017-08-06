//
//  FavoriteCollectionViewCell.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
}
