//
//  LoginViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var studentEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let studentEmail = studentEmailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
       
        
        Auth.auth().signIn(withEmail: studentEmail, password: password){ [weak self] (authResult, error) in
                    if let error = error {
                        // Handle login error and display the error message when the login was not ok
                    } else {
                        // Login successful, Jump to the teacher app menu.
                     
                    }
                }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
}
