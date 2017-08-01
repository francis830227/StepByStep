//
//  TextFieldDelegate.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/30.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension EverydayEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        eventTextField.resignFirstResponder()
        return true
    }
    
}
