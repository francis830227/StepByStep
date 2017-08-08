//
//  DailyViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit



class DailyViewController: UIViewController {

    let weekDays = ["Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday"]

    override func viewDidLoad() {
        super.viewDidLoad()


        
    
    }

    


}

extension DailyViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailycell", for: indexPath) as! DailyTableViewCell
        
        cell.weekDayLabel.text = weekDays[indexPath.row]
        
        return cell
    }

    
    
}
