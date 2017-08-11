//
//  DailyViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase





class DailyViewController: UIViewController {

    @IBOutlet weak var dailyTextField: UITextField!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    let weekDays = ["Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday"]
    
    var weekDaysNumber = [Int]()
    
    var yearString = ""
    
    var monthString = ""
    
    var dayString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        targetLabel.text = "目標日：\(yearString)/\(monthString)/\(dayString)"
        
        
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("Event").child(uid!)

        for number in weekDaysNumber {
            
//            ref.child("\(number)").childByAutoId()
            
            let values = ["endDate": "\(yearString)/\(monthString)/\(dayString)", "titleName": dailyTextField.text!]
            
            ref.child("\(number)").childByAutoId().updateChildValues(values)
            
        }
        
//        yearString = self.year.text ?? ""
//        
//        monthString = self.month.text ?? ""
//        
//        eventText = eventTextField.text ?? ""
//        
//        let values = ["year": yearString, "month": monthString, "day": dayString, "titleName": eventText]
        
        //ref.updateChildValues(values)

        
        
        dismiss(animated: true, completion: nil)
        
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
            
            if let index = weekDaysNumber.index(of: indexPath.row + 1) {
                weekDaysNumber.remove(at: index)
                print(weekDaysNumber)
            }
    
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            weekDaysNumber.append(indexPath.row + 1)
            print(weekDaysNumber)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

        
        
    }
    
    
    
    
}
