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
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var qrCodeLabel: UILabel!
    
    @IBOutlet weak var accessTimeLabel: UILabel!
    
    @IBOutlet weak var deviceInfoLabel: UILabel!
    
    var userEmail: String?
    var qrCodeData: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailLabel.text = userEmail
        qrCodeLabel.text = qrCodeData
        accessTimeLabel.text = getCurrentTime()
        deviceInfoLabel.text = getDeviceInfo()
        
        let event: String = "Attended"
        writeToFirebase(email: userEmail!, time: getCurrentTime(), event: event)
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
}

