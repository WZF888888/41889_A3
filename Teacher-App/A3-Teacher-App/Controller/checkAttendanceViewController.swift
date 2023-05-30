//
//  checkAttendanceViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/24.
//

import UIKit
import Firebase
import FirebaseFirestore


class checkAttendanceViewController: UIViewController,UITextFieldDelegate {
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var attendanceCodeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var functionDisable: Bool = false
    var attendanceData = [Attendance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceCodeTextField.delegate = self
        searchButton.isEnabled = false
    }
    
    //Handle User Not input any attendance code
    @IBAction func handleNoInput(_ sender: Any) {
        if attendanceCodeTextField.text == ""{
            errorLabel.text = "Please enter attendance code!"
            errorLabel.textColor = UIColor.red
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
            errorLabel.text = " "
        }
    }
    
    // Handle user click search button
    @IBAction func searchButtonClick(_ sender: Any) {
        let finalAttendanceCode = attendanceCodeTextField.text!
        checkIfCollectionExists(collectionName: finalAttendanceCode){ exists in
            if exists {
                // Get All Data
                self.getAllData(collerctionName: finalAttendanceCode)
            } else {
                self.errorLabel.text = "No Attendance Code in Database"
                self.errorLabel.textColor = UIColor.red
            }
        }
        // If there are data in the array then jump to the table view and display the dataset in table
        if !attendanceData.isEmpty {
            let finalattendanceData: [Attendance] = self.attendanceData
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "tableview") as! tableViewController
            VC.attendanceData = finalattendanceData
            VC.functionDisable = functionDisable
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    // Function that enable when user hit return on the keyboard and then the keyboard will be gone
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        attendanceCodeTextField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    // Function handle button click in nav that go back to the menu page.
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu") as! menuViewController
        MenuVC.functionDisable = functionDisable
        self.present(MenuVC, animated: true, completion: nil)
    }
    
    // helper function that get all dataset in a target firebase collection
    func getAllData(collerctionName: String){
        let db = Firestore.firestore()
        let collection = db.collection(collerctionName)
        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching attendance data: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }

            for document in documents {
                let data = document.data()
                if let userEmail = data["userEmail"] as? String,
                   let event = data["event"] as? String,
                   let time = data["time"] as? String {
                    let attendance = Attendance(userEmail: userEmail, event: event, time: time)
                    self.attendanceData.append(attendance)
                }
            }
        }
    }
    
    // Helper funcition that find out is the collection was already in the database
    func checkIfCollectionExists(collectionName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection(collectionName)
        collection.getDocuments { (snapshot, error) in
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
    
}
