//
//  deleteAssignmentController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/29.
//

import UIKit
import Firebase
import FirebaseFirestore

class deleteAssignmentController: UIViewController {
    
    @IBOutlet weak var codeInputTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isEnabled = false
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        let finalDelete = codeInputTextField.text!
        deleteCollection(collectionName: finalDelete) { error in
            if let error = error {
                print("Error deleting collection: \(error)")
            } else {
                print("Collection deleted successfully!")
            }
        }
    }
    
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
    
    
    
    
    
    func deleteCollection(collectionName: String, completion: @escaping (Error?) -> Void) {
        let firestore = Firestore.firestore()
        let collectionRef = firestore.collection(collectionName)
        
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(error)
                return
            }
            
            guard !snapshot.isEmpty else {
                completion(nil) // Collection is already empty
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
