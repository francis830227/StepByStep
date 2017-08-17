//
//  LeftViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/16.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import SwifterSwift

class LeftViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.blur(withStyle: .regular)
    }


    
}
