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
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
    }
    
    func bind() {
        
        contentView.backgroundColor = UIColor.lightGray
        
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOpacity = 1

    }
    
}

