//
//  MarkPresentViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import Foundation
import UIKit
import Firebase

class MarkPresentViewController: UIViewController {
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var qrCodeLabel: UILabel!
    
    @IBOutlet weak var accessTimeLabel: UILabel!
    
    @IBOutlet weak var deviceInfoLabel: UILabel!
    
    var userEmail: String?
    var qrCodeData: String?
    var remainingTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailLabel.text = userEmail
        qrCodeLabel.text = qrCodeData
        accessTimeLabel.text = getCurrentTime()
        deviceInfoLabel.text = getDeviceInfo()
        
        let event: String = "Attended"
        writeToFirebase(email: userEmail!, time: getCurrentTime(), event: event)
        
        // Start the session timer
        startSessionTimer()
    }
    
    func getCurrentTime() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: Date())
    }
    
    func getDeviceInfo() -> String {
            let device = UIDevice.current
            let deviceName = device.name
            
            return "Device Name: \(deviceName)"
    }
    
    func writeToFirebase(email: String,time: String,event: String) {
        //if update ok jump back to
        let db = Firestore.firestore()
        let collection = db.collection(qrCodeData!)
        let data: [String: Any] = [
            "userEmail": email,
            "time": time,
            "event": event
        ]
        collection.addDocument(data: data)
    }
    
    func startSessionTimer() {
        // Invalidate the previous timer if exists
        remainingTimer?.invalidate()
        
        // Schedule a new timer for 5 seconds
        remainingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(sessionEnds), userInfo: nil, repeats: false)
    }
        
    @objc func sessionEnds() {
        // Stop the session timer
        remainingTimer?.invalidate()
        
        // Show session timeout alert
        let alert = UIAlertController(title: "Attended!", message: "Please log in again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Sign out the student and navigate back to the login screen
            if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                self.navigationController?.setViewControllers([loginVC], animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

