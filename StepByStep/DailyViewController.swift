//
//  DailyViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit



class DailyViewController: UIViewController {

    @IBOutlet weak var dailyTextField: UITextField!
    
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

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)

        
        
    }

//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dailycell", for: indexPath) as! DailyTableViewCell
//        print("fdsa")
//        
//        cell.weekDayLabel.text = weekDays[indexPath.row]
//
//    }
    
    
}
