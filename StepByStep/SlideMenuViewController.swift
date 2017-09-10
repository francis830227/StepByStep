//
//  SlideMenuViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/16.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuViewController: SlideMenuController {

    override func awakeFromNib() {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        let controller = storyBoard.instantiateViewController(withIdentifier: "homeNVC")

        self.mainViewController = controller

        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "left") {

            self.leftViewController = controller
        }

        super.awakeFromNib()

    }

}
