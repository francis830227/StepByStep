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

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ref = Database.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            errorLabel.isHidden = false
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    print("You have successfully signed up.")
                    
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeVC") as! MainViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = homeViewController
                    
                    //self.ref?.childByAutoId().child("Posts").child("Name").setValue("\(self.firstNameTextField.text ?? "") \(self.lastNameTextField.text ?? "")")
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
}
