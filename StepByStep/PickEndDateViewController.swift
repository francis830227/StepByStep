//
//  PickEndDateViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/26.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import JTAppleCalendar
import IQKeyboardManagerSwift
import Firebase
import SkyFloatingLabelTextField

class PickEndDateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    let formatter = DateFormatter()
    
    let selectedMonthColor = UIColor.white
    
    let monthColor = UIColor.white
    
    let outsideMonthColor = UIColor.darkGray
    
    let todaysDate = Date()
        
    var yearString = ""
    
    var monthString = ""
    
    var dayString = ""
    
    var eventText = ""
    
    var eventKey = ""
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var eventTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var calendarViewHeightCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()

        gradientNavi()
        
        setupCalendarView()
        
        setupEventImageView()
    }
    
    @IBAction func donePickEndButtonPressed(_ sender: Any) {
        
        if yearString == "" || monthString == "" || dayString == "" || eventTextField.text == "" {
            
            let alert = UIAlertController(title: "沒有事件或日期不能存啦！", message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
                
                alert.dismiss(animated: true, completion: nil)
                
            })

            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            eventText = eventTextField.text ?? ""
            
            uploadToFirebase(eventImageView.image, yearString, monthString, dayString, eventText)
            
            dismiss(animated: true, completion: nil)
        }
    }

    
    func uploadToFirebase(_ image: UIImage?, _ year: String, _ month: String, _ day: String, _ eventText: String) {
        
        let uniqueString = NSUUID().uuidString
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("title").child(uid!).childByAutoId()
        
        guard let photo = image else { return }
        
        let photoComp = UIImageJPEGRepresentation(photo, 0.2)
        
        let storageRef = Storage.storage().reference().child("favoriteImage").child(uid!).child("\(uniqueString).png")
        
        if let uploadData = photoComp {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                
                if error != nil {
                    
                    print("Error: \(error!.localizedDescription)")
                    
                    return
                }
                
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    
                    print("Photo URL: \(uploadImageUrl)")
                    
                    let values = ["year": year, "month": month, "day": day, "titleName": eventText, "image": uploadImageUrl]
                    
                    ref.updateChildValues(values)
                }
                
            })
            
        }

    }
    
    func textFieldShouldReturn(_ eventTextField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    func setupCalendarView() {
        
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.layer.shadowColor = UIColor.black.cgColor
        
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        
        calendarView.layer.masksToBounds = false
        
        calendarView.layer.shadowOpacity = 1
        
        calendarView.layer.shadowRadius = 2

        calendarView.scrollToDate(Date())
        
        calendarView.selectDates([ Date() ])
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            
            self.setupViewOfCalendar(from: visibleDates)
        }
        
    }

    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }
        
        formatter.dateFormat = "yyyy MMM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            
            validCell.dateLabel.textColor = UIColor(red: 44/255.0, green: 243/255.0, blue: 255/255.0, alpha: 1)
            
        } else {
            
            if cellState.isSelected {
                
                validCell.dateLabel.textColor = selectedMonthColor
                
            } else {
                
                if cellState.dateBelongsTo == .thisMonth {
                    
                    validCell.dateLabel.textColor = monthColor
                    
                } else {
                    
                    validCell.dateLabel.textColor = outsideMonthColor
                }
                
            }
            
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = view as? CalendarCell else { return }
        
        if validCell.isSelected {
            
            validCell.selectedView.isHidden = false

        } else {
            
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellVisibility(view: JTAppleCell?, cellState: CellState) {
    
        guard let validCell = view as? CalendarCell else { return }

        validCell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"

        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MM"
        
        self.month.text = self.formatter.string(from: date)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupEventImageView() {
        
        let imageView = darkView!
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapEventImageView(sender: )))
        
        tapRecognizer.delegate = self
        
        imageView.addGestureRecognizer(tapRecognizer)
        
        imageView.isUserInteractionEnabled = true
    }
    
    func handleTapEventImageView(sender: UITapGestureRecognizer) {
        
        let photoAlert = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
        
        photoAlert.darkAlert(photoAlert)
        
        photoAlert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            
            self.openCamera()
            
        }))
        
        photoAlert.addAction(UIAlertAction(title: "Pick from album", style: .default, handler: { _ in
            
            self.openAlbum()
            
        }))
        
        photoAlert.addAction(UIAlertAction(title: "Choose from favorite places", style: .default, handler: { _ in
            
            self.openPlace()
            
        }))
        
        photoAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(photoAlert, animated: true)
    }

    func openCamera() {
        
        let isCameraExist = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if isCameraExist {
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true)
            
        } else {
            
            let noCaremaAlert = UIAlertController(title: "Sorry", message: "You don't have camera lol", preferredStyle: .alert)
            
            noCaremaAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(noCaremaAlert, animated: true)
        }
        
    }
    
    func openAlbum() {
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true)
        
    }
    
    func openPlace() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "googlephotoNVC")
        
        self.present(viewController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true) { () -> Void in
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.eventImageView.image = image
                
                self.eventImageView.contentMode = .scaleAspectFill
                
            } else {
                
                print("Something went wrong")
            }
        }
    }
}
