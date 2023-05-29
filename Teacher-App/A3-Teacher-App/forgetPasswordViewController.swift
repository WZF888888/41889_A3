//
//  forgetPasswordViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/30.
//

import UIKit

class forgetPasswordViewController: UIViewController {
    var userEmail:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleButtonClickBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "loginMain")
        self.present(menuVC, animated: true, completion: nil)
    }
}
