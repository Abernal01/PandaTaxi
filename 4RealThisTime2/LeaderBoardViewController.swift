//
//  LeaderBoardViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 4/4/23.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    var attributeToRetrieve = "fares_completed"
    
    @IBOutlet weak var dataTypeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        // Call the Firebase database reference with the default attribute value
        loadData(forAttribute: attributeToRetrieve)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Function to load data for a given attribute
    func loadData(forAttribute attribute: String) {
        attributeToRetrieve = attribute
        users.removeAll()
        
        let usersRef = Database.database().reference().child("users")
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let usersDict = snapshot.value as? [String:Any] {
                for (userId, userData) in usersDict {
                    if let userDict = userData as? [String:Any] {
                        if let attributeDict = userDict[attribute] as? [String:Any], let total = attributeDict["total"] as? Int {
                            let user = User(id: userId, attributeValue: total)
                            self.users.append(user)
                        }
                    }
                }
                
                // Sort users in descending order based on attribute value
                self.users.sort { $0.attributeValue > $1.attributeValue }
                
                self.tableView.reloadData()
            }
        })
    }
    
    // Function to handle button press
    @IBAction func loadBreaksSkippedData(_ sender: Any) {
        loadData(forAttribute: "breaks_skipped")
        dataTypeLbl.text = "Breaks Skipped"
    }
    @IBAction func loadBreaksTakenData(_ sender: Any) {
        loadData(forAttribute: "breaks_taken")
        dataTypeLbl.text = "Breaks Taken"
    }
    @IBAction func loadFaresCompletedData(_ sender: Any) {
        loadData(forAttribute: "fares_completed")
        dataTypeLbl.text = "Fares Completed"
    }
    @IBAction func loadCrashesData(_ sender: Any) {
        loadData(forAttribute: "car_accidents")
        dataTypeLbl.text = "Car Accidents"
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        let attributeValue = String(user.attributeValue)
        //cell.textLabel?.font = UIFont(name: "Menlo", size: 16)
       // cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        //cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
    
      
        
        // Retrieve user email instead of user id
        let usersRef = Database.database().reference().child("users").child(user.id)
        usersRef.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            if let userData = snapshot.value as? [String:Any], let email = userData["email"] as? String {
                
                cell.textLabel?.text = "\(email)\t\t\t\t\t\(attributeValue)"
            }
        })
        
        return cell
    }
    
}

class User {
    var id: String
    var attributeValue: Int
    
    init(id: String, attributeValue: Int) {
        self.id = id
        self.attributeValue = attributeValue
    }
}
