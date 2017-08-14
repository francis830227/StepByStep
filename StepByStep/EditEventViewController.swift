//
//  EditEventViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/13.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class EditEventViewController: UIViewController {

    var yearString = ""
    
    var monthString = ""
    
    var dayString = ""
    
    var eventText = ""
    
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()
    }
    @IBAction func datePickerShow(_ sender: SkyFloatingLabelTextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        
        // 設置 UIDatePicker 格式
        datePicker.datePickerMode = .date
        
        datePicker.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        datePicker.date = Date()
        
        sender.inputView = datePicker
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .blackOpaque
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        doneButton.tintColor = .white
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        cancelButton.tintColor = .white
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        toolBar.isUserInteractionEnabled = true
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
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
            
            let alert = UIAlertController(title: "Can't save event without date or event title.", message: "", preferredStyle: .alert)
            
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
