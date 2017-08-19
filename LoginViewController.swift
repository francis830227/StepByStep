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
import NVActivityIndicatorView
import SlideMenuControllerSwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        dismissKeyboard()
        
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

                    UserDefaults.standard.setValue(Auth.auth().currentUser?.uid, forKey: "uid")

                    UserDefaults.standard.synchronize()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let mainViewController = storyboard.instantiateViewController(withIdentifier: "homeNVC")
                    
                    let leftViewController = storyboard.instantiateViewController(withIdentifier: "left")
                    
                    let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)

                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = slideMenuController
                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    
                    alertController.darkAlert(alertController)
                    
                    alertController.setValue(NSAttributedString(string: "Error", attributes: [NSForegroundColorAttributeName : UIColor.white]), forKey: "attributedTitle")
                    
                    alertController.setValue(NSAttributedString(string: (error?.localizedDescription)!, attributes: [NSForegroundColorAttributeName : UIColor.gray]), forKey: "attributedMessage")
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

}
