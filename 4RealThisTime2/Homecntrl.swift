//
//  ViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 10/24/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth


class Homecntrl: UIViewController {
    
    @IBOutlet weak var timerInput: UITextField!
    @IBOutlet weak var coinValueLbl: UILabel!
   
    @IBOutlet weak var dropDownBtn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var characterHome: UIImageView!
    @IBOutlet var carHome: UIImageView!
    @IBOutlet var homeBG: UIImageView!
    @IBAction func StartButton(_ sender: Any) {
        UserDefaults.standard.set(timerInput.text, forKey: "time")
        
        
    }
        
    @IBAction func menuOnClick(_ sender: Any){
        if tableView.isHidden {
             animate(toogle: true, type: dropDownBtn)
        } else {
             animate(toogle: false, type: dropDownBtn)
        }
  }

   
    
 
    
    var menuList = ["Store", "Stats", "Music", "Login", "Sign Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        setResources()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        coinValueLbl.text = UserDefaults.standard.integer(forKey: "CoinsTotal").formatted()
        
        if let DefaultTime = UserDefaults.standard.string(forKey: "time"){
            timerInput.text = DefaultTime
            
        }
        
        tableView.reloadData()
        
        
        
    
    }
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func animate(toogle: Bool, type: UIButton) {
             
           if type == dropDownBtn {
                 
               if toogle {
                   UIView.animate(withDuration: 0.3) {
                       self.tableView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.tableView.isHidden = true
                   }
               }
           }
    }
    
    
    
    func setResources(){
        let a = UserDefaults.standard.bool(forKey: "foxBool")
        let b = UserDefaults.standard.bool(forKey: "nightBool")
        let c = UserDefaults.standard.bool(forKey: "convertBool")
        
        if (a){
            characterHome.loadGif(asset: "foxHome")
        }else{
            characterHome.loadGif(asset: "pandahome")
        }
        if(b){
            homeBG.image = UIImage(named: "nightHome")
        }
        if(c){
            carHome.image = UIImage(named: "convertMain")
        }
    }
    
    
    
}

extension Homecntrl: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pls", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        dropDownBtn.setTitle("\(menuList[indexPath.row])", for: .normal)
        animate(toogle: false, type: dropDownBtn)
        
        switch indexPath.row {
               case 0:
                   performSegue(withIdentifier: "storeSegue", sender: self)
               case 1:
                   performSegue(withIdentifier: "statsSegue", sender: self)
               case 2:
                   performSegue(withIdentifier: "musicSegue", sender: self)
               case 3:
                   performSegue(withIdentifier: "loginSegue", sender: self)
                case 4:
            do {
                   try Auth.auth().signOut()
                   // Restart the app
                   guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                       return
                   }
                   let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                   sceneDelegate.window?.rootViewController = viewController
               } catch let signOutError as NSError {
                   print("Error signing out: %@", signOutError)
               }
                    
               default:
                   break
               }
    }

}
