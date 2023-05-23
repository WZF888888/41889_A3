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
        guard let studentEmail = studentEmailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: studentEmail, password: password) { [weak self] (authResult, error) in
            if let error = error {
                // Handle login error and display the error message in the login view
                self?.displayAlert(withTitle: "Login Error", message: "Incorrect Email or Password.", completion: {
                    // Navigate to the LoginViewController in the storyboard
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self?.navigationController?.setViewControllers([loginVC], animated: true)})
            } else {
                // Login successful, jump to the student scene
                self?.displayAlert(withTitle: "Login Successful", message: "", completion: {})
            }
        }
    }

    func displayAlert(withTitle title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func forgotButtonTapped(_ sender: Any) {
        let alertTitle = "Forgot your password?"
        let alertMessage = "Please contact IT Support or visit UTS Student Centre."
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
