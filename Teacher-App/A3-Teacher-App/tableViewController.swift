//
//  tableViewController.swift
//  A3-Teacher-App
//
//  Created by John Wang on 2023/5/30.
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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Register the cell identifier
    }
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "checkCode")
        self.present(VC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let attendance = attendanceData![indexPath.row]
        cell.textLabel?.text = "User Email: \(attendance.userEmail) \(attendance.event)\nat time: \(attendance.time)"
        //cell.detailTextLabel?.text = "Event: \(attendance.event)\nTime: \(attendance.time)"
        cell.textLabel?.numberOfLines = 3
        return cell
    }
}
