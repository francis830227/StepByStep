//
//  FavTableViewCell.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/10.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImageView: UIImageView!

    @IBOutlet weak var storeNameLabel: UILabel!

    @IBOutlet weak var storeAddressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

}
