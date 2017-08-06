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
    
    @IBOutlet weak var dotImageView: UIImageView!
    
    func selectedViewLayout() {
        
        selectedView.layer.cornerRadius = selectedView.frame.size.width/2
        
        selectedView.clipsToBounds = true

        selectedView.layer.borderColor = UIColor.white.cgColor
        selectedView.layer.borderWidth = 1.0
        
        selectedView.bounce()
        
    }

}

//bounce animation
extension UIView {
    
    func bounce() {
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.beginFromCurrentState, animations:
            {
                
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                
        })
        
    }
    
}

