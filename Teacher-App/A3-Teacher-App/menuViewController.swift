//
//  menuViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/29.
//

import UIKit

class menuViewController: UIViewController {

    var userEmail: String = "Test"
    var functionDisable: Bool = false
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var createButton: UIButton!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButton()
    }
    
    func disableButton(){
        if functionDisable != false{
            createButton.isEnabled = false
        }
    }
    @IBAction func handleButtonClickCheck(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "checkCode") as! checkAttendanceViewController
        menuVC.functionDisable = functionDisable
        self.present(menuVC, animated: true, completion: nil)
    }
    @IBAction func handleButtonClickDelete(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "deleteView") as! deleteAssignmentController
        menuVC.functionDisable = functionDisable
        self.present(menuVC, animated: true, completion: nil)
    }
    
    @IBAction func handleButtonClickCreate(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "createAssignment") as! createAssignmentViewController
        menuVC.userEmail = userEmail
        self.present(menuVC, animated: true, completion: nil)
    }
    @IBAction func handleQuitApp(_ sender: UIButton) {
        exit(0)
    }
}
