//
//  Gradient.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/30.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension PickEndDateViewController {

    func gradientNavi() {

        var colors = [UIColor]()
        colors.append(UIColor(red: 27/255, green: 33/255, blue: 33/255, alpha: 1))
        colors.append(UIColor(red: 57/255, green: 71/255, blue: 71/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}

extension UINavigationBar {

    func setGradientBackground(colors: [UIColor]) {

        var updatedFrame = bounds

        updatedFrame.size.height += 20

        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)

        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}

extension CAGradientLayer {

    convenience init(frame: CGRect, colors: [UIColor]) {

        self.init()

        self.frame = frame

        self.colors = []
        for color in colors {

            self.colors?.append(color.cgColor)
        }

        startPoint = CGPoint(x: 0, y: 0.5)

        endPoint = CGPoint(x: 1, y: 0.5)
    }

    func creatGradientImage() -> UIImage? {

        var image: UIImage? = nil

        UIGraphicsBeginImageContext(bounds.size)

        if let context = UIGraphicsGetCurrentContext() {

            render(in: context)

            image = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()

        return image
    }
}
