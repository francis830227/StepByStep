//
//  LeftViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/16.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import SwifterSwift
import UserNotifications

class LeftViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userBackImageView: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var triangleImageView: UIImageView!

    @IBOutlet weak var tapView: UIView!

    var user: User?

    let imagePicker = UIImagePickerController()

    let fetchManager = FetchManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        userBackImageView.blur(withStyle: .regular)

        fetchManager.delegate = self

        fetchManager.requestUser()

        setupUserImageView()

        self.userImageView.contentMode = .scaleAspectFit

    }

    func uploadToFirebase(_ image: UIImage?) {

        let uniqueString = NSUUID().uuidString

        let uid = Auth.auth().currentUser?.uid

        let ref = Database.database().reference().child("users").child(uid!)

        guard let photo = image else { return }

        let photoComp = UIImageJPEGRepresentation(photo, 0.6)

        let storageRef = Storage.storage().reference().child("userImage").child(uid!).child("\(uniqueString).png")

        if let uploadData = photoComp {

            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in

                if error != nil {

                    print("Error: \(error!.localizedDescription)")

                    return
                }

                if let uploadImageUrl = data?.downloadURL()?.absoluteString {

                    let values = ["image": uploadImageUrl]

                    ref.updateChildValues(values)
                }

            })

        }

    }

    private func setupUserImageView() {

        let tap = tapView!

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapUserImageView(sender: )))

        tapRecognizer.delegate = self

        tap.addGestureRecognizer(tapRecognizer)

        tap.isUserInteractionEnabled = true
    }

    func handleTapUserImageView(sender: UITapGestureRecognizer) {

        let photoAlert = UIAlertController(title: "Pick An Image", message: nil, preferredStyle: .actionSheet)

        photoAlert.darkAlert(photoAlert)

        photoAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in

            self.openCamera()
        }))

        photoAlert.addAction(UIAlertAction(title: "Album", style: .default, handler: { _ in

            self.openAlbum()
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

            let noCaremaAlert = UIAlertController(title: "Oops!", message: "Camera required", preferredStyle: .alert)

            noCaremaAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(noCaremaAlert, animated: true)
        }
    }

    func openAlbum() {

        imagePicker.delegate = self

        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        self.dismiss(animated: true) { () -> Void in

            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

                self.userImageView.image = image

                self.userImageView.contentMode = .scaleAspectFill

                self.userImageView.layer.masksToBounds = false
                self.userImageView.layer.cornerRadius = self.userImageView.frame.height/2
                self.userImageView.clipsToBounds = true

                self.uploadToFirebase(image)

            } else {

                print("Upload to firebase failed.")
            }

        }

    }

    @IBAction func logoutButtonPressed(_ sender: Any) {

        let alert = UIAlertController(title: "Log Out？", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)

        alert.darkAlert(alert)

        let sureAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.destructive, handler: { (_ : UIAlertAction) -> Void in

            try? Auth.auth().signOut()

            let defaults = UserDefaults.standard

            defaults.removeObject(forKey: "uid")

            let appDelegate = UIApplication.shared.delegate as? AppDelegate

            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let controller =  mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController

            appDelegate?.window?.rootViewController = controller
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in

            alert.dismiss(animated: true, completion: nil)

        })

        alert.addAction(sureAction)
        alert.addAction(cancelAction)

        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        self.present(alert, animated: true, completion: nil)
    }

}

extension LeftViewController: FetchManagerDelegate {

    func manager(didGet data: [EndDate]) {

        return
    }

    func manager(didGet data: [FavoritePlace]) {
        return
    }

    func manager(didGet data: User?) {

        self.user = data

        userNameLabel.text = "\(self.user?.firstName ?? "No user name") \(self.user?.lastName ?? "")"

        userImageView.sd_setShowActivityIndicatorView(true)
        userImageView.sd_setIndicatorStyle(.white)

        if user?.imageUrl != nil {
        userImageView.sd_setImage(with: URL(string: (user?.imageUrl)!), completed: nil)
        }
    }

    func manager(didGet data: [HistoryEvent]) {
        return
    }
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! LeftTableViewCell
        // swiftlint:enable force_cast

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailView", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}
