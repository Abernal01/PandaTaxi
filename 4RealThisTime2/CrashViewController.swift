//
//  CrashViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 11/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseDatabase
import Firebase

class CrashViewController: UIViewController {

    @IBOutlet var crashBG: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        crashBG.loadGif(asset: "Crash")
        updateCarAccidents()
        
        // Do any additional setup after loading the view.
    }
   
    func updateCarAccidents() {
        guard let user = Auth.auth().currentUser else {
            // User is not signed in
            return
        }

        // Get current date
        let currentDate = Date()
        let calendar = Calendar.current

        let databaseRef = Database.database().reference(withPath: "users/\(user.uid)/car_accidents")

        // Child nodes for years, months, weeks, and days
        let yearRef = databaseRef.child(String(calendar.component(.year, from: currentDate)))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        let monthRef = yearRef.child(dateFormatter.string(from: currentDate))
        let weekRef = monthRef.child("Week \(calendar.component(.weekOfYear, from: currentDate))")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        let dayRef = weekRef.child(dateFormatter.string(from: currentDate))

        dayRef.runTransactionBlock { (mutableData) -> TransactionResult in
            var currentFaresCompleted = mutableData.value as? Int ?? 0
            currentFaresCompleted += 1
            mutableData.value = currentFaresCompleted
            return TransactionResult.success(withValue: mutableData)
        } andCompletionBlock: { (error, committed, snapshot) in
            if error != nil {
                // Log error
            } else {
                // Log success
            }
        }

        let cumulativeRef = databaseRef.child("total")
        cumulativeRef.runTransactionBlock { (mutableData) -> TransactionResult in
            var currentCount = mutableData.value as? Int ?? 0
            currentCount += 1
            mutableData.value = currentCount
            return TransactionResult.success(withValue: mutableData)
        } andCompletionBlock: { (error, committed, snapshot) in
            if error != nil {
                // Log error
            } else {
                // Log success
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
