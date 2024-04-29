//
//  StatisticViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 3/14/23.
//

import UIKit
import Firebase
import FirebaseAuth

class StatisticViewController: UIViewController {
    
    
    @IBOutlet private weak var breaksTaken: UILabel!
    @IBOutlet private weak var breaksSkipped: UILabel!
    @IBOutlet private weak var carAccidents: UILabel!
    @IBOutlet private weak var faresCompleted: UILabel!
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    var refCarAcc: DatabaseReference!
    var refFaresComp: DatabaseReference!
    var refBreaksTaken: DatabaseReference!
    var refBreaksSkipped: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refCarAcc = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/car_accidents")
        refFaresComp = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/fares_completed")
        refBreaksTaken = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/breaks_taken")
        refBreaksSkipped = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)/breaks_skipped")
        
        let date = datePicker.date
        retrieveDataForDate(date: date)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        retrieveDataForDate(date: date)
    }
    
    func retrieveDataForDate(date: Date) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let weekday = DateFormatter().weekdaySymbols[calendar.component(.weekday, from: date) - 1]
        
        let carAccRef = refCarAcc.child("\(year)/\(month)/Week \(weekOfYear)/\(weekday)")
        let faresCompRef = refFaresComp.child("\(year)/\(month)/Week \(weekOfYear)/\(weekday)")
        let breaksTakenRef = refBreaksTaken.child("\(year)/\(month)/Week \(weekOfYear)/\(weekday)")
        let breaksSkippedRef = refBreaksSkipped.child("\(year)/\(month)/Week \(weekOfYear)/\(weekday)")
        
        carAccRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                self.carAccidents.text = String(count)
            } else {
                self.carAccidents.text = "0"
            }
        }
        
        faresCompRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                self.faresCompleted.text = String(count)
            } else {
                self.faresCompleted.text = "0"
            }
        }
        
        breaksTakenRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                self.breaksTaken.text = String(count)
            } else {
                self.breaksTaken.text = "0"
            }
        }
        
        breaksSkippedRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                self.breaksSkipped.text = String(count)
            } else {
                self.breaksSkipped.text = "0"
            }
        }
    }}
