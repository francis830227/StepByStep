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
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    func bind() {
        contentView.backgroundColor = UIColor.lightGray
        testLabel.text = "\(arc4random_uniform(1000))"

    }
}

