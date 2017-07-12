//
//  TaskViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 5/13/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD
import Money

class TaskViewController: UIViewController, Table2Delegate, NabungDelegate, TarikDelegate, TransferDelegate, JajanDelegate {
    
    let userzat = Users()
    var userObject: UserObject = UserObject()

    @IBOutlet weak var saldoKasUser: UILabel!
    
    @IBOutlet weak var saldoTabunganUser: UILabel!
    
    func table2WillDismissed(){
        self.dismiss(animated: true, completion: nil)
        viewDidAppear(false)
    }
    
    func refreshpage() {
        viewDidAppear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let username = UserDefaults.standard.object(forKey: "userzat") as! String
        
        userzat.loadUser(loginusername: username,completed: { (success) -> Void in
            SVProgressHUD.dismiss()
            
            if success { // this will be equal to whatever value is set in this method call
                
                
                let kasTemp: Money = (Money(self.userzat.kas))
                let kasRupiah = "\(kasTemp)"
                
                let tabunganTemp: Money = Money(self.userzat.tabungan)
                let tabunganRupiah = "\(tabunganTemp)"
                
                self.saldoKasUser.text = "\((kasRupiah))"//.substring(from: kasRupiah.index(after: kasRupiah.startIndex )))"
                self.saldoTabunganUser.text = "\((tabunganRupiah))"//.substring(from: tabunganRupiah.index(after: tabunganRupiah.startIndex )))"
            } else {
                self.showAlert("Gagal Load Data", title: "Error")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    @IBAction func jajanButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "JajanSegue", sender: nil)
    }

    @IBAction func transferButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "TransferSegue", sender: nil)
    }

    @IBAction func tarikButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "TarikSegue", sender: nil)
    }
    
    @IBAction func nabungButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "NabungSegue", sender: nil)
    }

    @IBAction func dapetDuitButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "MasukSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "JajanSegue" {
            let js = segue.destination as! JajanViewController
            js.userzat = self.userzat
            js.jajanDelegate = self
        } else if segue.identifier == "TransferSegue" {
            let tf = segue.destination as! TransferViewController
            tf.userzat = self.userzat
            tf.transferDelegate = self
        } else if segue.identifier == "TarikSegue" {
            let ts = segue.destination as! TarikDuitViewController
            ts.userzat = self.userzat
            ts.tarikDelegate = self
        } else if segue.identifier == "NabungSegue" {
            let ns = segue.destination as! NabungViewController
            ns.userzat = self.userzat
            ns.nabungDelegate = self
        } else if segue.identifier == "MasukSegue" {
            let dd = segue.destination as! DapetDuitViewController
            dd.userzat = self.userzat
            dd.table2Delegate = self
        }
        
    }

}
