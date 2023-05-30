//
//  LoginViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBOutlet weak var studentEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isKeyboardVisible = false // keyboard
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let studentEmail = studentEmailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: studentEmail, password: password) { [weak self] (authResult, error) in
            if error != nil {
                // Handle login error and display the error message in the login view
                
                let alert = UIAlertController(title: "Login Error!", message: "Incorrect Email or Password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                }))
                self?.present(alert, animated: true, completion: nil)

            } else {
                // Login successful, jump to the student view
                
                let alert = UIAlertController(title: "Login Successful!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if let studentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentViewController") as? StudentViewController {
                        studentVC.email = studentEmail
                        self?.navigationController?.setViewControllers([studentVC], animated: true)
                    }
                }))
                self?.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func forgotButtonTapped(_ sender: Any) {
        let alertTitle = "Forgot your password?"
        let alertMessage = "Please contact IT Support or visit UTS Student Centre."
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // show keyboard
        isKeyboardVisible = true
        
        
        // set typed text color
        textField.textColor = UIColor.black
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isKeyboardVisible = false
        return true
    }

    
    @objc func handleTapGesture() {
        if isKeyboardVisible {
            view.endEditing(true)
            isKeyboardVisible = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        studentEmailTextField.delegate = self
        passwordTextField.delegate = self
        
        // secure password
        passwordTextField.isSecureTextEntry = true
        
        
    }
    
}


