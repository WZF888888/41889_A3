//
//  createAssignmentViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/23.
//

import UIKit
import Firebase
import FirebaseFirestore

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
        let finalcode:String = attendanceCodeInputLabel.text!
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
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu")
        self.present(MenuVC, animated: true, completion: nil)
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        attendanceCodeInputLabel.resignFirstResponder() // Dismiss the keyboard
        return true
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
                let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu") as! menuViewController
                MenuVC.functionDisable = true
                self.present(MenuVC, animated: true, completion: nil)
            }
        }
    }
}

