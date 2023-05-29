//
//  checkAttendanceViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/29.
//

import UIKit

class checkAttendanceViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var attendanceCodeTextField: UITextField!
    
    
    
    @IBAction func handleNoInput(_ sender: Any) {
        if attendanceCodeTextField.text == ""{
            errorLabel.text
        }
    }
    
    
}
