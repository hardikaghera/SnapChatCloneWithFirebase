//
//  ViewController.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    private let CONSTACTS_SEGUE_ID = "ContactsVC"
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.instance.isLoggedIn() {
            performSegue(withIdentifier: CONSTACTS_SEGUE_ID, sender: nil)
        }
    }

    @IBAction func signInButtonTapped(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                if message != nil {
                    self.showAlertMessage(title: "Problem with Authentication", message: message!)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: self.CONSTACTS_SEGUE_ID, sender: nil)
                    
                }
            })
            
        } else {
            showAlertMessage(title: "Email and Password are required", message: "Please enter email and password in the text Field")
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.performSegue(withIdentifier: self.CONSTACTS_SEGUE_ID, sender: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil{
                    self.showAlertMessage(title: "Problem with Sign Up", message: message!)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: self.CONSTACTS_SEGUE_ID, sender: nil)
                }
            })
        } else {
            showAlertMessage(title: "Email and Password are required", message: "Please enter email and password in the text Field")
            
        }
    }
    
    private func showAlertMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    
    }


} // Class

