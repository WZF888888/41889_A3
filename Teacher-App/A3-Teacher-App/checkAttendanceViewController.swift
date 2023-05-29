//
//  checkAttendanceViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/29.
//

import UIKit
import Firebase
import FirebaseFirestore


class checkAttendanceViewController: UIViewController {
    
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var attendanceCodeTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var attendanceData = [Attendance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isEnabled = false
    }
    
    
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
    
    @IBAction func searchButtonClick(_ sender: Any) {
        let finalAttendanceCode = attendanceCodeTextField.text!
        checkIfCollectionExists(collectionName: finalAttendanceCode){ exists in
            if exists {
                // Get All Data
                self.getAllData(collerctionName: finalAttendanceCode)
            } else {
                print("Collection does not exist in Firebase Firestore.")
                self.errorLabel.text = "No Attendance Code in Database"
            }
        }
        

        if !attendanceData.isEmpty {
            var finalattendanceData: [Attendance] = self.attendanceData
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC = storyboard.instantiateViewController(withIdentifier: "tableview") as! tableViewController
            menuVC.attendanceData = finalattendanceData
            self.present(menuVC, animated: true, completion: nil)
        }

    }
    
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
    
}
