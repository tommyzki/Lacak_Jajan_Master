//
//  TarikDuitViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/5/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD

class TarikDuitViewController: UIViewController {
    
    var userzat = Users()
    var historyzat = Historys()
    var tarikDelegate: TarikDelegate?

    @IBOutlet weak var viewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var nominalUang: UITextField!
    
    @IBAction func tarikButtonTapped(_ sender: Any) {
        
        let username = userzat.username
        
        guard let valuez = nominalUang.text, valuez.characters.count > 0 else {
            self.showAlert("Nominal cannot be empty.", title: "Error")
            return
        }
        
        if (Int(valuez)! < userzat.tabungan) {
            
            let kasvalue = "\(userzat.kas + Int(valuez)! )"
            let tabunganvalue = "\(userzat.tabungan - Int(valuez)!)"
            let kasparam = "kas"
            let tabunganparam = "tabungan"
            
            userzat.updateUser(username: username, params: kasparam, value: kasvalue, completed: { (success) -> Void in
                
                if success { // this will be equal to whatever value is set in this method call
                    self.userzat.updateUser(username: username, params: tabunganparam, value: tabunganvalue, completed: { (success) -> Void in
                        if success { // this will be equal to whatever value is set in this method call
                            self.historyzat.addHistory(addusername: username, addtype: "Tarik Duit", adddesc: "", addnominal: valuez , completed: { (success) -> Void in
                                self.view.endEditing(true)
                                SVProgressHUD.dismiss()
                                
                                if success { // this will be equal to whatever value is set in this method call
                                    self.showAlert("Success berhasil Tarik Uang", title: "Success")
                                    
                                    if let delegate = self.tarikDelegate {
                                        delegate.table2WillDismissed()
                                    }
                                } else {
                                    self.showAlert("Error Gagal melakukan tarik uang", title: "Error")
                                }
                            })
                        } else {
                            self.showAlert("Error Gagal melakukan tarik uang", title: "Error")
                        }
                    })
                } else {
                    self.showAlert("Error Gagal melakukan tarik uang", title: "Error")
                }
            })
        } else {
            self.showAlert("Jumlah Tabungan Lebih kecil dari jumlah yang di Tarik", title: "Error")
        }
    }

    @IBAction func bgButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation Keyboard
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.viewBottomCons.constant = 186.5
            } else {
                self.viewBottomCons.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

protocol TarikDelegate {
    func table2WillDismissed()
}
