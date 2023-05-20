//
//  loginViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/20.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameInputTextfield: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    var inputTureForUsername:Bool = false;
    var inputTureForPassword:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
    }
    
    @IBAction func handleUserNameNoInput(_ sender: Any) {
        if usernameInputTextfield.text == "" {
            errorLabel1.text = "Please Enter the name in text field"
            errorLabel1.textColor = UIColor.red
            inputTureForUsername = false
        } else {
            errorLabel1.text = " "
            inputTureForUsername = true
        }
        controlButton(inputTureForUsername: inputTureForUsername, inputTureForPassword: inputTureForPassword)
    }
    
    @IBAction func handlePasswordNoInput(_ sender: Any) {
        if passwordInputTextField.text == "" {
            errorLabel2.text = "Please Enter the password in text field"
            errorLabel2.textColor = UIColor.red
            inputTureForPassword = false
        } else {
            errorLabel2.text = " "
            inputTureForPassword = true
        }
        controlButton(inputTureForUsername: inputTureForUsername, inputTureForPassword: inputTureForPassword)
    }
    
    func controlButton(inputTureForUsername:Bool, inputTureForPassword: Bool){
        if inputTureForUsername == true && inputTureForPassword == true {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}


