//
//  SplashsViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/5/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD

class SplashViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var regLogView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var bottomViewLayout: NSLayoutConstraint!
    
    @IBOutlet weak var loginUsernameText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    
    @IBOutlet weak var regLastNameText: UITextField!
    @IBOutlet weak var regEmailText: UITextField!
    @IBOutlet weak var regUsernameText: UITextField!
    @IBOutlet weak var regPasswordText: UITextField!
    
    var animationOnAppearEnabled = true
    
    func loginAndFetchData() {
        
        guard let username = loginUsernameText.text, username.characters.count > 0 else {
            self.showAlert("Username cannot be empty.", title: "Error")
            return
        }
        guard let password = loginPasswordText.text, password.characters.count > 0 else {
            self.showAlert("Password cannot be empty", title: "Error")
            return
        }
        
        UserObject.fetchUserData(username: username, result: { (result, error) in
            self.view.endEditing(true)
            SVProgressHUD.dismiss()
            if let userObjects = result {
                print(userObjects.password)
                if (userObjects.password == password) {
                    userObject = userObjects
                    UserDefaults.standard.set(username, forKey: "userzat")
                    self.performSegue(withIdentifier: "taskSegue", sender: nil)
                } else {
                    self.showAlert("Username / Password Salah", title: "Error", okAction: {
                        self.loginPasswordText.text = ""
                    })
                }
            } else if let error = error {
                print(error)
                if (error._code == 1){
                    self.showAlert("Could not connect to the server. Please Try Again", title: "Error")
                }
                else {
                    self.showAlert("Username / Password Salah", title: "Error", okAction: {
                        self.loginPasswordText.text = ""
                    })
                }
            }
        })
    }
    
    func registerUser() {
        
        guard let fullname = regLastNameText.text, fullname.characters.count > 0 else {
            self.showAlert("Name cannot be empty.", title: "Error")
            return
        }
        guard let email = regEmailText.text, email.characters.count > 0 else {
            self.showAlert("Email cannot be empty.", title: "Error")
            return
        }
        guard let username = regUsernameText.text, username.characters.count > 0 else {
            self.showAlert("Username cannot be empty.", title: "Error")
            return
        }
        guard let password = regPasswordText.text, password.characters.count > 0 else {
            self.showAlert("Password cannot be empty", title: "Error")
            return
        }
        
        UserObject.createNewUser(username: username, password: password, email: email, fullname: fullname ) { success, error in
            self.view.endEditing(true)
            SVProgressHUD.dismiss()
            if success {
                self.showAlert("Your changes has been saved.", title: "Success") {
                    self.bgButtonTapped(1)
                }
            } else if let error = error {
                print(error)
                if (error._code == 1){
                    self.showAlert("Could not connect to the server. Please Try Again", title: "Error")
                }
                else {
                    self.showAlert("\(error.localizedDescription)", title: "Error")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set status bar to light color
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.alpha = 0
        registerView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: (animationOnAppearEnabled ? 0.5 : 0)) {
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: (animationOnAppearEnabled ? 1: 0)) {
            self.regLogView.alpha = 1
        }
    }
    
    // MARK: - Navigation Button Tapped
    
    @IBAction func bgButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.alpha = 0
            self.loginView.alpha = 0
        }, completion: { finished in
            UIView.animate(withDuration: 0.2) {
                self.regLogView.alpha = 1
            }
        })
        
    }
    
    @IBAction func reglogLoginButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.regLogView.alpha = 0
            self.loginView.alpha = 1
            self.registerView.alpha = 0
        }
        
    }
    
    @IBAction func reglogRegisterButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.regLogView.alpha = 0
            self.loginView.alpha = 0
            self.registerView.alpha = 1
        }
    }
    
    @IBAction func logLoginButtonTapped(_ sender: Any) {
        loginAndFetchData()
    }
    
    
    @IBAction func regRegisterButtonTapped(_ sender: Any) {
        registerUser()
        
    }
    
    // MARK: - Keyboard2
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == regLastNameText {
            regEmailText.becomeFirstResponder()
        } else if textField == regEmailText {
            regUsernameText.becomeFirstResponder()
        } else if textField == regUsernameText {
            regPasswordText.becomeFirstResponder()
        } else if textField == regPasswordText {
            regRegisterButtonTapped(1)
        }
        
        if textField == loginUsernameText {
            loginPasswordText.becomeFirstResponder()
        } else if textField == loginPasswordText {
            logLoginButtonTapped(1)
        }
        
        return true
        
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomViewLayout.constant = 0.0
            } else {
                self.bottomViewLayout.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "taskSegue" {
            let tabCtrl = segue.destination as! UITabBarController
            let vc1 = tabCtrl.viewControllers![0] as! UINavigationController
            vc1.title = "Home"
            
            let vc2 = tabCtrl.viewControllers![1] as! UINavigationController
            vc2.title = "History"
            
            let vc3 = tabCtrl.viewControllers![2] as! UINavigationController
            vc3.title = "Other"
        }
    }
}
