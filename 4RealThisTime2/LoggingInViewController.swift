//
//  LoggingInViewController.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 3/14/23.
//

import UIKit
import FirebaseAuth

class LoggingInViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        progressView.isHidden = true
        loginBtn.addTarget(self, action: #selector(loginUserAccount), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
           view.addGestureRecognizer(tapGesture)
    }
    
    @objc func loginUserAccount() {

        // show the visibility of progress view to show loading
        progressView.isHidden = false

        // Take the value of two text fields in Strings
        guard let email = emailTxt.text, !email.isEmpty else {
            showAlert(message: "Please enter email!!")
            return
        }

        guard let password = passwordTxt.text, !password.isEmpty else {
            showAlert(message: "Please enter password!!")
            return
        }

        // signin existing user
        auth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }

            if let error = error {
                // sign-in failed
                self.showAlert(message: "Login failed!! \(error.localizedDescription)")
            } else {
                // sign-in successful
                self.showAlert(message: "Login successful!!") { _ in
                    // hide the progress view
                    self.progressView.isHidden = true

                    // if sign-in is successful
                    // navigate to home screen
                    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Homecntrl") as! Homecntrl
                    self.present(homeVC, animated: true, completion: nil)
                }
            }
        }
    }

    func showAlert(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true, completion: nil)
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


