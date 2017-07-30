//
//  MainCollectionViewCell.swift
//  
//
//  Created by Francis Tseng on 2017/7/25.
//
//

import UIKit
import AnimatedCollectionViewLayout

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var finishDateLabel: UILabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var totalGoingLabel: UILabel!
    
    @IBOutlet weak var todayGoingLabel: UILabel!
    
    @IBOutlet weak var addCardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
    }
    
    func bind() {
        
        contentView.backgroundColor = UIColor.lightGray

    }
    
}

