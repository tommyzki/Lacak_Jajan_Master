//
//  SettingViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/7/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD

class SettingViewController: UIViewController {
    
    let userzat = Users()
    let historyzat = Historys()

    @IBOutlet weak var fullNameText: UILabel!
    
    @IBAction func clearHistoryButtonTapped(_ sender: Any) {
        
        historyzat.clearHistory(completed: { (success) -> Void in
            SVProgressHUD.dismiss()
            if success { // this will be equal to whatever value is set in this method call
                self.showAlert("Success, history berhasil di hapus", title: "Success")
            } else {
                self.showAlert("Gagal Load Data", title: "Error")
            }
        })
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userzat")
        performSegue(withIdentifier: "rootSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        fullNameText.text = userObject.fullname

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue" {
            let _ = segue.destination as! RootViewController
        }
    }

}
