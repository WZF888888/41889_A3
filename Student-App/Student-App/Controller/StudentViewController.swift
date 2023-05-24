//
//  StudentViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import Foundation
import UIKit

class StudentViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    var email: String?
    var sessionTimer: Timer?
    var remainingTime: TimeInterval = 60 * 5 // Set the desired session timeout duration in seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailLabel.text = email
        
        // Set the current date in the date label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        dateLabel.text = dateString
        
        startSessionTimer()
    }

    func startSessionTimer() {
        sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer() // Update the initial timer display
    }

    @objc func updateTimer() {
        remainingTime -= 1
        timerLabel.text = timeFormatted(remainingTime)
        
        if remainingTime == 0 {
            logout()
        }
    }

    func logout() {
        sessionTimer?.invalidate()
        
        // sign out the student and navigate back to the login screen
        if let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.setViewControllers([loginVC], animated: true)
        }
    }

    // remaining time in mm:ss format
    func timeFormatted(_ totalSeconds: TimeInterval) -> String {
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

}
