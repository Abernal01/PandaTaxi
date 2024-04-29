//
//  BreakViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 11/3/22.
//

import UIKit
import Firebase

class BreakViewController: UIViewController {
    
    @IBOutlet weak var countdownBreakLbl: UILabel!
    
    @IBOutlet weak var SkipButtonTxt: UIButton!
    
    @IBOutlet var breakBG: UIImageView!
    
    @IBOutlet weak var LetsDriveBtn: UIButton!
   
    @IBAction func skipBreak(_ sender: Any) {
        updateBreaksSkippedCounter()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Drive") as! DriveViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    
    var timer = Timer()
    var timerValue = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setResources()
        LetsDriveBtn.isHidden = true
       
        
        countdownBreakLbl.text =  timeString(time: TimeInterval(timerValue))

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
        
        
    }
    
    func setResources(){
        let a = UserDefaults.standard.bool(forKey: "foxBool")
        if (a){
            breakBG.loadGif(asset: "foxBreakScreen")
        }else{
            breakBG.loadGif(asset: "pandaBreakScreen")
        }
    }
    
    @objc func countDownMethod(){
        //timer countdown by 1 sec
        timerValue -= 1
        countdownBreakLbl.text = timeString(time: TimeInterval(timerValue))
        
        //timer stops when it hits 0
        if timerValue == 0{
            timer.invalidate()
            updateBreaksTakenCounter()
            SkipButtonTxt.isHidden = true
            LetsDriveBtn.isHidden = false
            
        }
    }
        
        func timeString(time:TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    
    func updateBreaksSkippedCounter() {
        guard let user = Auth.auth().currentUser else {
            // User is not signed in
            return
        }
        // Get current date
        let currentDate = Date()
        let calendar = Calendar.current

        let databaseRef = Database.database().reference(withPath: "users/\(user.uid)/breaks_skipped")

        // Child nodes for years, months, weeks, and days
        let yearRef = databaseRef.child("\(calendar.component(.year, from: currentDate))")
        let monthRef = yearRef.child("\(DateFormatter().monthSymbols[calendar.component(.month, from: currentDate) - 1])")
        let weekRef = monthRef.child("Week \(calendar.component(.weekOfYear, from: currentDate))")
        let dayRef = weekRef.child("\(DateFormatter().weekdaySymbols[calendar.component(.weekday, from: currentDate) - 1])")

        dayRef.runTransactionBlock { (mutableData) -> TransactionResult in
            var currentBreaksSkipped = mutableData.value as? Int ?? 0
            currentBreaksSkipped += 1
            mutableData.value = currentBreaksSkipped
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
    
    func updateBreaksTakenCounter() {
        guard let user = Auth.auth().currentUser else {
            // User is not signed in
            return
        }
        // Get current date
        let currentDate = Date()
        let calendar = Calendar.current

        let databaseRef = Database.database().reference(withPath: "users/\(user.uid)/breaks_taken")

        // Child nodes for years, months, weeks, and days
        let yearRef = databaseRef.child("\(calendar.component(.year, from: currentDate))")
        let monthRef = yearRef.child("\(DateFormatter().monthSymbols[calendar.component(.month, from: currentDate) - 1])")
        let weekRef = monthRef.child("Week \(calendar.component(.weekOfYear, from: currentDate))")
        let dayRef = weekRef.child("\(DateFormatter().weekdaySymbols[calendar.component(.weekday, from: currentDate) - 1])")

        dayRef.runTransactionBlock { (mutableData) -> TransactionResult in
            var currentBreaksSkipped = mutableData.value as? Int ?? 0
            currentBreaksSkipped += 1
            mutableData.value = currentBreaksSkipped
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

