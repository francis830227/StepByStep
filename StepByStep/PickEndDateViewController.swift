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
import NVActivityIndicatorView

class PickEndDateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, GetImageDelegate {

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

    // swiftlint:disable force_cast
    let pickGooglePhotoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "googlephoto") as! PickGooglePhotoViewController
    // swiftlint:enable force_cast

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

        formatter.dateFormat = "yyyy"
        yearString = formatter.string(from: todaysDate)

        formatter.dateFormat = "MM"
        monthString = formatter.string(from: todaysDate)

        formatter.dateFormat = "dd"
        dayString = formatter.string(from: todaysDate)
    }

    @IBAction func donePickEndButtonPressed(_ sender: Any) {

        if eventTextField.text == "" {

            let alert = UIAlertController(title: "Can't save event without title", message: "", preferredStyle: .alert)

            alert.darkAlert(alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in

                alert.dismiss(animated: true, completion: nil)

            })

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)

        } else {

            eventText = eventTextField.text ?? ""

            let activityData = ActivityData()

            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

            NVActivityIndicatorPresenter.sharedInstance.setMessage("Saving...")

            uploadToFirebase(eventImageView.image, yearString, monthString, dayString, eventText)

            dismiss(animated: true, completion: nil)
        }
    }

    func uploadToFirebase(_ image: UIImage?, _ year: String, _ month: String, _ day: String, _ eventText: String) {

        let uniqueString = NSUUID().uuidString

        let uid = Auth.auth().currentUser?.uid

        let ref = Database.database().reference().child("title").child(uid!).childByAutoId()

        guard let photo = image else { return }

        let photoComp = UIImageJPEGRepresentation(photo, 0.6)

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

    func setImagePickedFromGoogle(_ imageUrl: String) {

        eventImageView.contentMode = .scaleAspectFill

        eventImageView.sd_setShowActivityIndicatorView(true)

        eventImageView.sd_setIndicatorStyle(.white)

        eventImageView.sd_setImage(with: URL(string: imageUrl))
    }

    private func setupEventImageView() {

        let imageView = darkView!

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapEventImageView(sender: )))

        tapRecognizer.delegate = self

        imageView.addGestureRecognizer(tapRecognizer)

        imageView.isUserInteractionEnabled = true
    }

    func handleTapEventImageView(sender: UITapGestureRecognizer) {

        let photoAlert = UIAlertController(title: "Pick An Image", message: nil, preferredStyle: .actionSheet)

        photoAlert.darkAlert(photoAlert)

        photoAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in

            self.openCamera()

        }))

        photoAlert.addAction(UIAlertAction(title: "Album", style: .default, handler: { _ in

            self.openAlbum()

        }))

        photoAlert.addAction(UIAlertAction(title: "Favorite Places", style: .default, handler: { _ in

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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        self.dismiss(animated: true) { () -> Void in

            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

                self.eventImageView.contentMode = .scaleAspectFill

                self.eventImageView.image = image

            } else {

                print("Something went wrong")
            }
        }
    }
}
