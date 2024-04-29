//
//  SignUpViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 3/31/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        registerBtn.addTarget(self, action: #selector(registerNewUser), for: .touchUpInside)
    }
    
    @objc func registerNewUser() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        guard let email = emailTxt.text, !email.isEmpty,
              let password = passwordTxt.text, !password.isEmpty
        else {
            showAlert(withTitle: "Error", message: "Please enter both email and password")
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let uid = result?.user.uid else {
                self.showAlert(withTitle: "Error", message: "Unable to get user ID")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            let databaseRef = Database.database().reference()
            let usersRef = databaseRef.child("users")
            let userDict = ["email": email]
            usersRef.child(uid).setValue(userDict) { (error, databaseRef) in
                if let error = error {
                    self.showAlert(withTitle: "Error", message: error.localizedDescription)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                self.showAlert(withTitle: "Success", message: "Registration successful!")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
