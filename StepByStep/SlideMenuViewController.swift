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
        
        print("awake")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
