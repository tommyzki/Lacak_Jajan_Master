//
//  DapetDuitViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/6/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD

class DapetDuitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var userzat = Users()
    var historyzat = Historys()
    var table2Delegate: Table2Delegate?

    @IBOutlet weak var viewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    @IBOutlet weak var nominalUang: UITextField!
    @IBOutlet weak var deskripsi: UITextField!
    
    @IBAction func dapetDuitButtonTapped(_ sender: Any) {
        
        let username = userzat.username
        guard let params = textBox.text, params.characters.count > 0 else {
            self.showAlert("Jenis Uang Jajan cannot be empty.", title: "Error")
            return
        }
        guard let valuez = nominalUang.text, valuez.characters.count > 0 else {
            self.showAlert("Nominal cannot be empty.", title: "Error")
            return
        }
        
        let deskrip = deskripsi.text
        
        var value: String
        
        if (params == "Kas") {
            value = "\(Int(valuez)! + userzat.kas)"
        } else {
            value = "\(Int(valuez)! + userzat.tabungan)"
        }
        
        userzat.updateUser(username: username, params: params, value: value, completed: { (success) -> Void in
            if success { // this will be equal to whatever value is set in this method call
                self.historyzat.addHistory(addusername: username, addtype: "Masukan (\(params)) ", adddesc: deskrip!, addnominal: valuez , completed: { (success) -> Void in
                    self.view.endEditing(true)
                    SVProgressHUD.dismiss()
                    if success { // this will be equal to whatever value is set in this method call
                        self.showAlert("Uang Jajan berhasil masuk ke \(params)", title: "Success")
                        if let delegate = self.table2Delegate {
                            delegate.table2WillDismissed()
                        }
                    } else {
                        self.showAlert("Error Gagal mendapatkan Uang", title: "Error")
                    }
                })
            } else {
                self.showAlert("Error Gagal mendapatkan Uang", title: "Error")
            }
        })
    }
    
    @IBAction func bgButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var list = ["Kas", "Tabungan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DropDown
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textBox.text = self.list[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
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

protocol Table2Delegate {
    func table2WillDismissed()
}
