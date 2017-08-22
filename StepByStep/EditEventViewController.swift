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

class EditEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate,GetImageDelegate {

    var yearString = ""
    
    var monthString = ""
    
    var dayString = ""
    
    var eventText = ""
    
    var imageURL = ""
    
    var eventKey = ""
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var editTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var darkView: UIView!
    
    let pickGooglePhotoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "googlephoto") as! PickGooglePhotoViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextField.delegate = self
        
        dateTextField.text = "\(yearString)/\(monthString)/\(dayString)"
        
        editTextField.text = "\(eventText)"
        
        editImageView.sd_setImage(with: URL(string: imageURL))
        
        editImageView.contentMode = .scaleAspectFill
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()
        
        setupEventImageView()
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
        
        dateFormatter.dateFormat = "yyyy"
        
        yearString = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "MM"
        
        monthString = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "dd"
        
        dayString = dateFormatter.string(from: sender.date)
        
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
    
    func textFieldShouldReturn(_ eventTextField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if yearString == "" || monthString == "" || dayString == "" || dateTextField.text == "" {
            
            let alert = UIAlertController(title: "Can't save event without date or title.", message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
                
                alert.dismiss(animated: true, completion: nil)

            })

            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {

            eventText = editTextField.text ?? ""
            
            uploadToFirebase(editImageView.image, yearString, monthString, dayString, eventText)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadToFirebase(_ image: UIImage?, _ year: String, _ month: String, _ day: String, _ eventText: String) {
        
        let uniqueString = NSUUID().uuidString
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("title").child(uid!).child(eventKey)
        
        guard let photo = image else { return }
        
        let photoComp = UIImageJPEGRepresentation(photo, 0.5)
        
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
        
        photoAlert.addAction(UIAlertAction(title: "Pick from favorite places", style: .default, handler: { _ in
            
            self.openPlace()
            
        }))
        
        photoAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        photoAlert.popoverPresentationController?.sourceView = self.view
        photoAlert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        photoAlert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
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
        
        pickGooglePhotoViewController.delegate = self
        
        self.present(pickGooglePhotoViewController, animated: true, completion: nil)
    }
    
    func setImagePickedFromGoogle(_ imageUrl: String) {
        
        editImageView.contentMode = .scaleAspectFill
        
        editImageView.sd_setShowActivityIndicatorView(true)
        
        editImageView.sd_setIndicatorStyle(.white)
        
        editImageView.sd_setImage(with: URL(string: imageUrl))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true) { () -> Void in
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.editImageView.image = image
                
                self.editImageView.contentMode = .scaleAspectFill
                
            } else {
                
                print("Something went wrong")
            }
            
        }
        
    }

}
