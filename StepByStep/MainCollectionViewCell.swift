//
//  MainCollectionViewCell.swift
//  
//
//  Created by Francis Tseng on 2017/7/25.
//
//

import UIKit
import AnimatedCollectionViewLayout
import GradientView

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var finishDateLabel: UILabel!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var gradientView: GradientView!
    
    let firstColorOne = UIColor(red: 19/255, green: 198/255, blue: 201/255, alpha: 1)
    let firstColorTwo = UIColor(red: 45/255, green: 130/255, blue: 187/255, alpha: 1)
    let firstColorThree = UIColor(red: 83/255, green: 77/255, blue: 182/255, alpha: 1)
    let firstColorFour = UIColor(red: 120/255, green: 20/255, blue: 178/255, alpha: 1)
    //let firstColors: [UIColor] = [firstColorOne, firstColorTwo, firstColorThree, firstColorFour]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    func bind() {
        
        contentView.backgroundColor = UIColor.lightGray
        
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOpacity = 2
        
        //gradientView.colors = [firstColorOne, firstColorTwo, firstColorThree, firstColorFour]
        

        
    }
    
}

