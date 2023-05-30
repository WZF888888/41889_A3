//
//  tableViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/25.
//

import UIKit

struct Attendance {
    let userEmail: String
    let event: String
    let time: String
}

class tableViewController: UIViewController, UITableViewDataSource {
    
    //Disable landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var attendanceData: [Attendance]?
    var functionDisable: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Register the cell identifier
    }
    
    // Function handle button click in nav that go back to the previous page.
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "checkCode") as! checkAttendanceViewController
        VC.functionDisable = functionDisable
        self.present(VC, animated: true, completion: nil)
    }
    
    // For setting table view number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceData?.count ?? 0
    }
    
    // For setting the table cell details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let attendance = attendanceData![indexPath.row]
        cell.textLabel?.text = "User Email: \(attendance.userEmail) \(attendance.event)\nat time: \(attendance.time)"
        // Max line of the each table cell
        cell.textLabel?.numberOfLines = 3
        return cell
    }
}
