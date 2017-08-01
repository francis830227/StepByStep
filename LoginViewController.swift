//
//  LoginViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/7/25.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            errorLabel.isHidden = false
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {

                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeVC") as! MainViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = homeViewController
                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }

}
