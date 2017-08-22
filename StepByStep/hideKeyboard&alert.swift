//
//  hideKeyboard.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/30.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIAlertController {
    
    func darkAlert(_ alert: UIAlertController) {
        let firstSubview = alert.view.subviews.first
        let alertContentView = firstSubview?.subviews.first
        for subview in (alertContentView?.subviews)! {
            subview.tintColor = .white
            subview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            subview.alpha = 0.7
        }
        alert.view.tintColor = .white
        
    }
    
}
