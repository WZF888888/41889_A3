//
//  createAssignmentViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class createAssignmentViewController: UIViewController {
    var userEmail:String = ""
    var teachInputCode = ""
    var attendancCode = ""
    @IBOutlet weak var attendanceCodeInputLabel: UITextField!
    @IBOutlet weak var createAssignmentButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAssignmentButton.isEnabled = false
    }
    
    @IBAction func handleNoAttendanceCodeInput(_ sender: Any) {
        if attendanceCodeInputLabel.text == "" {
            errorLabel.text = "Enter Code"
            errorLabel.textColor = UIColor.red
            createAssignmentButton.isEnabled = false
        } else {
            errorLabel.text = " "
            createAssignmentButton.isEnabled = true
        }
    }
    
    @IBAction func handleCreateAssignmentButtonOnclick(_ sender: Any) {
        let createTimeFrame:String = currentTime()
        let event:String = "Create Assignment";
        attendancCode = attendanceCodeInputLabel.text!;
        writeToFirebase(email: self.userEmail,time: createTimeFrame,event: event)
    }
    
    func currentTime() -> String{
        let tempTimeWithoutRefector = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalReturnDateString = dateFormatter.string(from: tempTimeWithoutRefector)
        return finalReturnDateString
    }
    
    func writeToFirebase(email: String,time: String,event: String) {
        //if update ok jump back to
        let db = Firestore.firestore()
        let collection = db.collection(attendancCode)
        let data: [String: Any] = [
            "userEmail": email,
            "time": time,
            "event": event
        ]
        collection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MenuVC = storyboard.instantiateViewController(withIdentifier: "TeacherMenu")
                self.present(MenuVC, animated: true, completion: nil)
            }
        }
    }
}

