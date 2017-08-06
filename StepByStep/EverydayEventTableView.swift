//
//  EverydayEventTableView.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/29.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit

extension EverydayEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "everyDayTableViewCell", for: indexPath) as! EverydayEventTableViewCell
        
        // Configure the cell...
        
        cell.itemLabel.text = "teach William delegate."
        
        return cell
    }
}
