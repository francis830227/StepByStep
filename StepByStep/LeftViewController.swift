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

class LeftViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userBackImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var triangleImageView: UIImageView!
    
    var user: User?
    
    let imagePicker = UIImagePickerController()
    
    let fetchManager = FetchManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBackImageView.blur(withStyle: .regular)
        
        fetchManager.delegate = self
        
        fetchManager.requestUser()
    }

    func uploadToFirebase(_ image: UIImage?) {
        
        let uniqueString = NSUUID().uuidString
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("user").child(uid!)
        
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
        
        let imageView = userImageView!
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapUserImageView(sender: )))
        
        tapRecognizer.delegate = self 
        
        imageView.addGestureRecognizer(tapRecognizer)
        
        imageView.isUserInteractionEnabled = true
    }
    
    func handleTapUserImageView(sender: UITapGestureRecognizer) {
        
        let photoAlert = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
        
        photoAlert.darkAlert(photoAlert)
        
        photoAlert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            
            self.openCamera()
        }))
        
        photoAlert.addAction(UIAlertAction(title: "Pick from album", style: .default, handler: { _ in
            
            self.openAlbum()
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true) { () -> Void in
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.userImageView.image = image
                
                self.userImageView.contentMode = .scaleAspectFill
                
                self.uploadToFirebase(image)
                
            } else {
                
                print("Something went wrong")
            }
            
        }
        
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "確定登出？", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.darkAlert(alert)
        
        let sureAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) -> Void in
            
            try! Auth.auth().signOut()
            
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
}
