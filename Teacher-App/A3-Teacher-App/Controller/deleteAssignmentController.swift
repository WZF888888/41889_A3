//
//  deleteAssignmentController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class deleteAssignmentController: UIViewController,UITextFieldDelegate {
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var codeInputTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var functionDisable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeInputTextField.delegate = self
        deleteButton.isEnabled = false
    }
    
    //handle Delete function
    @IBAction func handleDelete(_ sender: Any) {
        let finalDelete = codeInputTextField.text!
        // Before delete chick the target deleted code was in the database. if it was in the database then call the deleteCollection function to delete it.
        // Else if not print error message to the label.
        checkIfCollectionExists(collectionName: finalDelete){ exists in
            if exists {
                self.deleteCollection(collectionName: finalDelete) { error in
                    if let error = error {
                        print("Error deleting collection: \(error)")
                    } else {
                        self.navControl()
                    }
                }
            } else {
                self.errorLabel.text = "No Attendance Code in Database"
                self.errorLabel.textColor = UIColor.red
            }
        }
        
    }
    
    // Function control the jumping to next page or get back to menu
    func navControl(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuVC = storyboard.instantiateViewController(withIdentifier: "teacherMenu") as! menuViewController
        MenuVC.functionDisable = functionDisable
        self.present(MenuVC, animated: true, completion: nil)
    }
    
    // Function that handle user click the back button in the nav bar
    @IBAction func handleNavBackClick(_ sender: Any) {
        navControl()
    }
    
    // handle no user input
    @IBAction func handleNoInput(_ sender: Any) {
        if codeInputTextField.text == ""{
            errorLabel.text = "Enter Code"
            errorLabel.textColor = UIColor.red
            deleteButton.isEnabled = false
        } else {
            errorLabel.text = " "
            deleteButton.isEnabled = true
        }
    }
    
    // Check is the Collection exist in the firebase database
    func checkIfCollectionExists(collectionName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection(collectionName)
        collection.getDocuments {
            (snapshot, error) in
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
        codeInputTextField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    // Delete the Collection Refrenceing from Google Firebase
    // Base on example in firebase learning center and modify based on the need
    func deleteCollection(collectionName: String, completion: @escaping (Error?) -> Void) {
        let firestore = Firestore.firestore()
        let collectionRef = firestore.collection(collectionName)
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(error)
                return
            }
            
            // Collection is already empty
            guard !snapshot.isEmpty else {
                completion(nil)
                return
            }
            
            let batch = firestore.batch()
            
            snapshot.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { batchError in
                if let batchError = batchError {
                    completion(batchError)
                } else {
                    completion(nil) // Deletion successful
                }
            }
        }
    }
}
