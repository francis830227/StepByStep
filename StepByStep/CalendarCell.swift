//
//  CalendarCell.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var eventDotView: UIView!
    
    func bind() {
        
        selectedView.layer.cornerRadius = selectedView.frame.size.width/2
        
        selectedView.clipsToBounds = true

        selectedView.layer.borderColor = UIColor.white.cgColor
        selectedView.layer.borderWidth = 1.0
        
    }

}
