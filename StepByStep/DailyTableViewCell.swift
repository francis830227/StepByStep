//
//  DailyTableViewCell.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var weekDayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 0.8)
//        selectedBackgroundView?.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 0.7)
        selectedBackgroundView = view

    }

}
