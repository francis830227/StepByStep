//
//  MainCollectionViewCell.swift
//  
//
//  Created by Francis Tseng on 2017/7/25.
//
//

import UIKit
import AnimatedCollectionViewLayout
import SwifterSwift

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var finishDateLabel: UILabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind() {
        
        contentView.backgroundColor = UIColor.lightGray
        
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOpacity = 2

    }
    
}

