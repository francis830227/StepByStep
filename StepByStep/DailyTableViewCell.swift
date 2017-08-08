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
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        if checkImageView.isHidden {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkImageView.tintColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
