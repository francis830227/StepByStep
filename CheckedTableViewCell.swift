//
//  CheckedTableViewCell.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/23.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

class CheckedTableViewCell: UITableViewCell {

    @IBOutlet weak var historyImageView: UIImageView!
    
    @IBOutlet weak var historyTitleLabel: UILabel!
    
    @IBOutlet weak var historyDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
