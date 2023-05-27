//
//  MarkPresentViewController.swift
//  Student-App
//
//  Created by Yeseul Shin on 23/5/2023.
//

import Foundation
import UIKit

class MarkPresentViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var qrCodeLabel: UILabel!
    
    @IBOutlet weak var accessTimeLabel: UILabel!
    
    @IBOutlet weak var deviceInfoLabel: UILabel!
    
    var email: String?
    var qrCodeData: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        qrCodeLabel.text = qrCodeData
    }


}

