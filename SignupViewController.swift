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

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            errorLabel.isHidden = false
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
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
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
