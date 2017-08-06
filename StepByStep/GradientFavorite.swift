//
//  GradientFavorite.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/2.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension FavoriteViewController {
    
    func gradientFavoriteNavi() {
        
        var colors = [UIColor]()
        colors.append(UIColor(red: 27/255, green: 33/255, blue: 33/255, alpha: 1))
        colors.append(UIColor(red: 57/255, green: 71/255, blue: 71/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 18)!]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        
    }
    
}

