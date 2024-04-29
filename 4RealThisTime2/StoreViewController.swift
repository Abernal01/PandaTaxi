//
//  StoreViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 11/15/22.
//

import UIKit
import Firebase


class StoreViewController: UIViewController {
    var pandaBool = true
    var dayBool = true
    var taxiBool = true
    
    var foxBool = false
    var nightBool = false
    var convertBool = false
    
    @IBOutlet var pandaOut: UISwitch!
    @IBOutlet var foxOut: UISwitch!
    
    @IBOutlet var dayOut: UISwitch!
    @IBOutlet var nightOut: UISwitch!
    
    @IBOutlet var taxiOut: UISwitch!
    @IBOutlet var convertOut: UISwitch!
    
    @IBOutlet var coinValueLbl: UILabel!
    
    @IBOutlet var buyBtn: UIButton!
    @IBOutlet var buyNightBtn: UIButton!
    @IBOutlet var buyConvertBtn: UIButton!
    @IBOutlet var unlockOtter: UIButton!
    @IBOutlet var unlockCountry: UIButton!
    @IBOutlet var unlockRacoon: UIButton!
    @IBOutlet var unlockMonkey: UIButton!
    @IBOutlet var unlockCountryNight: UIButton!
    @IBOutlet var unlockBeach: UIButton!
    @IBOutlet var unlockJeep: UIButton!
    @IBOutlet var unlockPickup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwicthes()
        coinValueLbl.text = UserDefaults.standard.integer(forKey: "CoinsTotal").formatted()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pandaSwicth(_ sender: UISwitch) {
        if(sender.isOn){
            pandaBool = true
            foxBool = false
            
            foxOut.setOn(false, animated: true)
            UserDefaults.standard.set(pandaBool, forKey: "pandaBool")
            UserDefaults.standard.set(foxBool, forKey: "foxBool")
            
        }
    }
    
    @IBAction func buybtnACT(_ sender: Any) {
        let foxCost = 25
        
        guard let user = Auth.auth().currentUser else {
            print("User not signed in")
            return
        }
        
        let databaseRef = Database.database().reference().child("users").child(user.uid).child("total_coins")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard var coins = snapshot.value as? Int else {
                print("total_coins node not found")
                return
            }
            
            coins -= foxCost
            databaseRef.setValue(coins) { error, _ in
                if let error = error {
                    print("Error updating total_coins node: \(error.localizedDescription)")
                    return
                }
                
                UserDefaults.standard.set(coins, forKey: "CoinsTotal")
                self.coinValueLbl.text = coins.formatted()
                print("total_coins node updated successfully")
                self.buyBtn.isHidden = true
            }
        }
    }
    
    @IBAction func buyNightAct(_ sender: Any) {
        let nightCost = 35
     
        guard let user = Auth.auth().currentUser else {
            print("User not signed in")
            return
        }
        
        let databaseRef = Database.database().reference().child("users").child(user.uid).child("total_coins")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard var coins = snapshot.value as? Int else {
                print("total_coins node not found")
                return
            }
            
            coins -= nightCost
            databaseRef.setValue(coins) { error, _ in
                if let error = error {
                    print("Error updating total_coins node: \(error.localizedDescription)")
                    return
                }
                
                UserDefaults.standard.set(coins, forKey: "CoinsTotal")
                self.coinValueLbl.text = coins.formatted()
                print("total_coins node updated successfully")
                self.buyNightBtn.isHidden = true
            }
        }
    }
    
    @IBAction func buyConvertAct(_ sender: Any) {
        let convertCost = 45
        
        guard let user = Auth.auth().currentUser else {
            print("User not signed in")
            return
        }
        
        let databaseRef = Database.database().reference().child("users").child(user.uid).child("total_coins")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard var coins = snapshot.value as? Int else {
                print("total_coins node not found")
                return
            }
            
            coins -= convertCost
            databaseRef.setValue(coins) { error, _ in
                if let error = error {
                    print("Error updating total_coins node: \(error.localizedDescription)")
                    return
                }
                
                UserDefaults.standard.set(coins, forKey: "CoinsTotal")
                self.coinValueLbl.text = coins.formatted()
                print("total_coins node updated successfully")
                self.buyConvertBtn.isHidden = true
            }
        }
    }
    
    @IBAction func daySwitch(_ sender: UISwitch) {
        if(sender.isOn){
            dayBool = true
            nightBool = false
            
            nightOut.setOn(false, animated: true)
            UserDefaults.standard.set(dayBool, forKey: "dayBool")
            UserDefaults.standard.set(nightBool, forKey: "nightBool")
        }
    }
    
    @IBAction func taxiSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            taxiBool = true
            convertBool = false
            
            convertOut.setOn(false, animated: true)
            UserDefaults.standard.set(taxiBool, forKey: "taxiBool")
            UserDefaults.standard.set(convertBool, forKey: "convertBool")
        }
    }
    
    @IBAction func foxSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            pandaBool = false
            foxBool = true
            
            pandaOut.setOn(false, animated: true)
            UserDefaults.standard.set(pandaBool, forKey: "pandaBool")
            UserDefaults.standard.set(foxBool, forKey: "foxBool")
            
        }
        
    }
    
    
    @IBAction func nightSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            nightBool = true
            dayBool = false
            
            dayOut.setOn(false, animated: true)
            UserDefaults.standard.set(dayBool, forKey: "dayBool")
            UserDefaults.standard.set(nightBool, forKey: "nightBool")
        }
    }
    
    @IBAction func convertSwitch(_ sender: UISwitch) {
        if(sender.isOn){
            convertBool = true
            taxiBool = false
            
            taxiOut.setOn(false, animated: true)
            UserDefaults.standard.set(taxiBool, forKey: "taxiBool")
            UserDefaults.standard.set(convertBool, forKey: "convertBool")
        }
    }
    
    func setSwicthes(){
        let a = UserDefaults.standard.bool(forKey: "pandaBool")
        let b = UserDefaults.standard.bool(forKey: "foxBool")
        let c = UserDefaults.standard.bool(forKey: "dayBool")
        let d = UserDefaults.standard.bool(forKey: "nightBool")
        let e = UserDefaults.standard.bool(forKey: "taxiBool")
        let f = UserDefaults.standard.bool(forKey: "convertBool")
        
        if(a) {
            pandaOut.isOn = true
            foxOut.isOn = false
        }else if(b){
            pandaOut.isOn = false
            foxOut.isOn = true
        }
        if(c){
            dayOut.isOn = true
            nightOut.isOn = false
        }else if (d){
            dayOut.isOn = false
            nightOut.isOn = true
        }
        if(e){
            taxiOut.isOn = true
            convertOut.isOn = false
        }else if (f){
            taxiOut.isOn = false
            convertOut.isOn = true
        }
    }
    
    func isGone() {
        let mSharedPreference = UserDefaults.standard
        
        let a = mSharedPreference.bool(forKey: "FOXBOOL")
        let b = mSharedPreference.bool(forKey: "NIGHTBOOL")
        let c = mSharedPreference.bool(forKey: "CONVERTBOOL")
        let d = mSharedPreference.bool(forKey: "OTTERBOOL")
        let e = mSharedPreference.bool(forKey: "COUNTRYBOOL")
        let f = mSharedPreference.bool(forKey: "RACOONBOOL")
        let g = mSharedPreference.bool(forKey: "MONKEYBOOL")
        let h = mSharedPreference.bool(forKey: "COUNTRYNIGHTBOOL")
        let i = mSharedPreference.bool(forKey: "BEACHBOOL")
        let j = mSharedPreference.bool(forKey: "JEEPBOOL")
        let k = mSharedPreference.bool(forKey: "PICKUPBOOL")
        
        if b {
            buyNightBtn.isHidden = true
        }
        if a {
            buyBtn.isHidden = true
        }
        if c {
            buyConvertBtn.isHidden = true
        }
        if d {
            unlockOtter.isHidden = true
        }
        if e {
            unlockCountry.isHidden = true
        }
        if f {
            unlockRacoon.isHidden = true
        }
        if g {
            unlockMonkey.isHidden = true
        }
        if h {
            unlockCountryNight.isHidden = true
        }
        if i {
            unlockBeach.isHidden = true
        }
        if j {
            unlockJeep.isHidden = true
        }
        if k {
            unlockPickup.isHidden = true
        }
    }
    
    
    
    


}
