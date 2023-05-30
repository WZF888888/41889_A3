//
//  loginViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/20.
//

import UIKit
import Firebase

class loginViewController: UIViewController,UITextFieldDelegate {
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var userEmailTextfield: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var systemErrorLabel: UILabel!
    
    var inputTureForUsername:Bool = false;
    var inputTureForPassword:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailTextfield.delegate = self
        passwordInputTextField.delegate = self
        loginButton.isEnabled = false
        passwordInputTextField.isSecureTextEntry = true
    }
    
    // Function that user had no email input in the text field, this will disable the button and give a error message.
    @IBAction func handleEmailNoInput(_ sender: Any) {
        if userEmailTextfield.text == "" {
            errorLabel1.text = "Please Enter the email"
            errorLabel1.textColor = UIColor.red
            inputTureForUsername = false
        } else {
            errorLabel1.text = " "
            inputTureForUsername = true
        }
        controlButton(inputTureForUsername: inputTureForUsername, inputTureForPassword: inputTureForPassword)
    }
    
    // Function that user had no password input in the text field, this will disable the button and give a error message.
    @IBAction func handlePasswordNoInput(_ sender: Any) {
        if passwordInputTextField.text == "" {
            errorLabel2.text = "Please Enter the password"
            errorLabel2.textColor = UIColor.red
            inputTureForPassword = false
        } else {
            errorLabel2.text = " "
            inputTureForPassword = true
        }
        controlButton(inputTureForUsername: inputTureForUsername, inputTureForPassword: inputTureForPassword)
    }
    
    // This is a helper function that enable or disable the button if need under some condition.
    func controlButton(inputTureForUsername:Bool, inputTureForPassword: Bool) {
        if inputTureForUsername == true && inputTureForPassword == true {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    // Function that enable when user hit return on the keyboard and then the keyboard will be gone
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailTextfield.resignFirstResponder() // Dismiss the keyboard
        passwordInputTextField.resignFirstResponder()
        return true
    }
    
    // This function handle the user click the login button. If login is okay it will jump to menu page and also passing data to the menu page.
    @IBAction func handleLoginClick(_ sender: Any) {
        let finalUsername:String = userEmailTextfield.text!
        let finalPassword:String = passwordInputTextField.text!
        // Using Firebase
        Auth.auth().signIn(withEmail: finalUsername, password: finalPassword){ [weak self] (authResult, error) in
            if let error = error {
                // Handle login error and display the error message when the login was not ok.
                self!.systemErrorLabel.text = "Email or Password Not Correct!"
                self!.systemErrorLabel.textColor = UIColor.red
                print("Login error: \(error.localizedDescription)")
            } else {
                // Login successful, Jump to the teacher app menu and give the data.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let menuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu") as! menuViewController
                menuVC.userEmail = finalUsername
                self!.present(menuVC, animated: true, completion: nil)
            }
        }
    }
}


