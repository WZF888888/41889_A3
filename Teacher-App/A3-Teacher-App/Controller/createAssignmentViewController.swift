//
//  createAssignmentViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/23.
//

import UIKit
import Firebase
import FirebaseFirestore
// In this page we have to use third party database system - Firebase
// In order to learn this the some code is taken from https://firebase.google.com/docs/ios/setup and we had modify to make it work in our project


class createAssignmentViewController: UIViewController,UITextFieldDelegate {
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var userEmail:String?
    var teachInputCode = ""
    var attendancCode = ""
    
    @IBOutlet weak var attendanceCodeInputLabel: UITextField!
    @IBOutlet weak var createAssignmentButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceCodeInputLabel.delegate = self
        createAssignmentButton.isEnabled = false

    }
    
    //Handle User Not input any attendance code
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
    
    //Handle User click create assignment button
    @IBAction func handleCreateAssignmentButtonOnclick(_ sender: Any) {
        let createTimeFrame:String = currentTime()
        let event:String = "Create Assignment";
        let finalcode:String = attendanceCodeInputLabel.text!
        // Check if the entered attendance code already exsit in the database
        checkIfCollectionExists(collectionName: finalcode){ exists in
            if exists {
                print("Collection exist in Firebase Firestore.")
                self.errorLabel.text = "Attendance Code already in Database"
            } else {
                self.attendancCode = finalcode
                self.writeToFirebase(email: self.userEmail!,time: createTimeFrame,event: event)
            }
        }
    }
    
    // Function for user hit back button in the nav bar
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu")
        self.present(MenuVC, animated: true, completion: nil)
    }
    
    // Helper funcition that find out is the collection was already in the database
    func checkIfCollectionExists(collectionName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(collectionName)
        
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error retrieving documents: \(error)")
                completion(false)
                return
            }
            
            if snapshot?.isEmpty == true {
                // Collection does not exist
                completion(false)
            } else {
                // Collection exists
                completion(true)
            }
        }
    }
    
    // Function that enable when user hit return on the keyboard and then the keyboard will be gone
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        attendanceCodeInputLabel.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    // Fucntion that get current system time
    func currentTime() -> String{
        let tempTimeWithoutRefector = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalReturnDateString = dateFormatter.string(from: tempTimeWithoutRefector)
        return finalReturnDateString
    }
    
    // Function that write data to the firebase database
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
                let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu") as! menuViewController
                MenuVC.functionDisable = true
                self.present(MenuVC, animated: true, completion: nil)
            }
        }
    }
}

