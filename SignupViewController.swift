//
//  SignupViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/25.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField
import SlideMenuControllerSwift
import NVActivityIndicatorView

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        firstNameTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let activityData = ActivityData()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            errorLabel.isHidden = false
            
            errorLabel.bounce()
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        } else {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    UserDefaults.standard.setValue(Auth.auth().currentUser?.uid, forKey: "uid")
                    
                    UserDefaults.standard.synchronize()
                    
                    let uid = Auth.auth().currentUser?.uid
                    
                    let ref = Database.database().reference().child("users").child(uid!)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let mainViewController = storyboard.instantiateViewController(withIdentifier: "homeNVC")
                    
                    let leftViewController = storyboard.instantiateViewController(withIdentifier: "left")
                    
                    let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)

                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = slideMenuController
                    
                    let values = ["email": self.emailTextField.text!, "firstName": self.firstNameTextField.text!, "lastName": self.lastNameTextField.text!]
                    
                    ref.updateChildValues(values)
                    
                } else {
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    alertController.darkAlert(alertController)
                    
                    alertController.setValue(NSAttributedString(string: "Error", attributes: [NSForegroundColorAttributeName : UIColor.white]), forKey: "attributedTitle")
                    
                    alertController.setValue(NSAttributedString(string: (error?.localizedDescription)!, attributes: [NSForegroundColorAttributeName : UIColor.white]), forKey: "attributedMessage")
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ eventTextField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
