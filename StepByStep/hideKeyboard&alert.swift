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
            subview.backgroundColor = .darkGray
            subview.layer.cornerRadius = 10
            subview.alpha = 1
        }
        alert.view.tintColor = .white
        
    }
    
}
