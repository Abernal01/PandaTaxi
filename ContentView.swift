//
//  ContentView.swift
//  PandaTaxi
//
//  Created by Milksteaks on 3/14/23.
//

import SwiftUI
import FirebaseAuthCombineSwift
import Gifu

class HomeScreen: UIViewController, PopupMenuDelegate {
    
    var counterTxt: UILabel!
    var coinTxt: UILabel!
    var setTimer: UIButton!
    var TimerTxt: UITextField!
    var time: Int64 = 25 * 60000
    var txtValue: String!
    var clicked: Bool = false
    var character: GIFImageView!
    var background: GIFImageView!
    var vehicle: UIImageView!
    
    var authUser: FirebaseAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = PopupMenu()
        menu.delegate = self
        if let user = Auth.auth().currentUser {
            menu.menuItems = [.store, .stats, .music, .signOut]
        } else {
            menu.menuItems = [.store, .stats, .music, .login]
        }
        
        counterTxt = UILabel()
        counterTxt.text = "\(0)"
        coinTxt = UILabel()
        setTimer = UIButton()
        TimerTxt = UITextField()
        character = GIFImageView()
        background = GIFImageView()
        vehicle = UIImageView()
        
        view.addSubview(counterTxt)
        view.addSubview(coinTxt)
        view.addSubview(setTimer)
        view.addSubview(TimerTxt)
        view.addSubview(character)
        view.addSubview(background)
        view.addSubview(vehicle)
        
        let mSharedPreference = UserDefaults.standard
        let value = mSharedPreference.integer(forKey: "COINS_VALUE")
        clicked = mSharedPreference.bool(forKey: "CLICK")
        
        counterTxt.text = "\(value)"
        let min = Int64(0)
        let coins = Int64()
        
        setTimer.addTarget(self, action: #selector(setTimerClicked), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setResources()
        
    }
    
    @objc func setTimerClicked() {
        guard let input = TimerTxt.text else { return }
        if input.count == 0 {
            let alert = UIAlertController(title: "Field can't be empty", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let millisInput = Int64(input) else { return }
        let timeInMillis = millisInput * 60000
        if timeInMillis == 0 {
            let alert = UIAlertController(title: "Please enter a positive number", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        setTime()
        let int = Intent(self, drivingScreen.self)
        int.putExtra("timer", time)
        self.present(int, animated: true, completion: nil)
    }
    
    func setTime() {
        let prefs = UserDefaults.standard
        time = prefs.integer(forKey: "TIMER_VALUE")
        txtValue = TimerTxt.text
        time = Int64(txtValue)! * 60000
        prefs.set(time, forKey: "TIMER_VALUE")
        prefs.synchronize()
    }
    
    func onMenuItemClick(_ menuItem: PopupMenuItem) -> Bool {
        switch menuItem {
        case .store:
            let int = Intent(self, storeScreen.self)
            self.present(int, animated: true, completion: nil)
            return true
        case .stats:
            let int = Intent(self, StatisticActivity.self)
            self.present(int, animated: true, completion: nil)
            return true
            
        }
        
    }}
