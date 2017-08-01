//
//  ViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/1.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var registerView: UIView!
    
    @IBOutlet var signinView: UIView!
    
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var regNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var regEmailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var regPasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var signinEmailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var signinPasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet var warningLabels: [UILabel]!
    
    var loginViewTopConstraint: NSLayoutConstraint!
    
    var registerTopConstraint: NSLayoutConstraint!
    
    var isLoginViewVisible = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        get {
        
            return UIInterfaceOrientationMask.portrait
        
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customization()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.layoutIfNeeded()
        
    }

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        self.showLoading(state: true)
        
        if regEmailTextField.text == "" || regPasswordTextField.text == "" {
            
            for item in self.warningLabels {
                
                item.isHidden = false
                
            }

        } else {
            
            Auth.auth().createUser(withEmail: self.regEmailTextField.text!, password: regPasswordTextField.text!) { (user, error) in
                
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
    
    @IBAction func signinButtonPressed(_ sender: UIButton) {
        
        signinEmailTextField.resignFirstResponder()
        
        signinPasswordTextField.resignFirstResponder()
        
        self.showLoading(state: true)
        
        if signinEmailTextField.text == "" || signinPasswordTextField.text == "" {
            
            for item in self.warningLabels {
                
                item.isHidden = false
                
            }
            
        } else {
            
            Auth.auth().signIn(withEmail: self.signinEmailTextField.text!, password: self.signinPasswordTextField.text!) { (user, error) in
                
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
    
    @IBAction func switchViews(_ sender: UIButton) {
        
        if self.isLoginViewVisible {
            
            self.isLoginViewVisible = false
            
            sender.setTitle("Login", for: .normal)
            
            self.loginViewTopConstraint.constant = 1000
            
            self.registerTopConstraint.constant = 60
        
        } else {
            
            self.isLoginViewVisible = true
            
            sender.setTitle("Create New Account", for: .normal)
            
            self.loginViewTopConstraint.constant = 60
            
            self.registerTopConstraint.constant = 1000
        
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
        
            self.view.layoutIfNeeded()
        
        })
        
        for item in self.warningLabels {
        
            item.isHidden = true
        
        }
        
    }
    
    func customization()  {
        self.darkView.alpha = 0
        //LoginView customization
        self.view.insertSubview(self.signinView, aboveSubview: self.darkView)
        self.signinView.translatesAutoresizingMaskIntoConstraints = false
        self.signinView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginViewTopConstraint = NSLayoutConstraint.init(item: self.signinView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.loginViewTopConstraint.isActive = true
        self.signinView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        self.signinView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.signinView.layer.cornerRadius = 8
        //RegisterView Customization
        self.view.insertSubview(self.registerView, aboveSubview: self.darkView)
        self.registerView.translatesAutoresizingMaskIntoConstraints = false
        self.registerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.registerTopConstraint = NSLayoutConstraint.init(item: self.registerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.registerTopConstraint.isActive = true
        self.registerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        self.registerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.registerView.layer.cornerRadius = 8
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for item in self.warningLabels {
            item.isHidden = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.indicatorView.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0
            }, completion: { _ in
                self.indicatorView.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! MainViewController
        self.show(vc, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
