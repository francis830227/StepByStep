//
//  EditEventViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/13.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase

class EditEventViewController: UIViewController {

    var yearString = ""
    
    var monthString = ""
    
    var dayString = ""
    
    var eventText = ""
    
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func datePickerPop(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        
        // 設置 UIDatePicker 格式
        datePicker.datePickerMode = .date
        
        datePicker.date = Date()
        
        sender.inputView = datePicker
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        toolBar.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "yyyy MM dd"
        
        dateTextField.text = dateFormatter1.string(from: sender.date)
        
    }
    
    //Picker Date Done Button
    func donePressed(_ sender: UIBarButtonItem) {
        
        dateTextField.resignFirstResponder()
        
    }
    
    func cancelClick() {
        
        dateTextField.resignFirstResponder()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if yearString == "" || monthString == "" || dayString == "" || dateTextField.text == "" {
            
            let alert = UIAlertController(title: "沒有事件或日期不能存哦！", message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
                
                alert.dismiss(animated: true, completion: nil)

            })

            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {

            let uid = Auth.auth().currentUser?.uid

            let ref = Database.database().reference().child("title").child(uid!).childByAutoId()
            
            eventText = dateTextField.text ?? ""
            
            let values = ["year": yearString, "month": monthString, "day": dayString, "titleName": eventText]
            
            ref.updateChildValues(values)
            
            dismiss(animated: true, completion: nil)
            
        }

    }
}
