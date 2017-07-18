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
    
    @IBOutlet weak var saldoKasUser: UILabel!
    
    @IBOutlet weak var saldoTabunganUser: UILabel!
    
    func table2WillDismissed(){
        self.dismiss(animated: true, completion: nil)
        refreshpage()
    }
    
    func refreshpage() {
        
        let kasTemp: Money = (Money(userObject.kas))
        let kasRupiah = "\(kasTemp)"
        
        let tabunganTemp: Money = Money(userObject.tabungan)
        let tabunganRupiah = "\(tabunganTemp)"
        
        self.saldoKasUser.text = "\((kasRupiah))"//.substring(from: kasRupiah.index(after: kasRupiah.startIndex )))"
        self.saldoTabunganUser.text = "\((tabunganRupiah))"//.substring(from: tabunganRupiah.index(after: tabunganRupiah.startIndex )))"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshpage()
        view.addBackground()
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
            js.jajanDelegate = self
        } else if segue.identifier == "TransferSegue" {
            let tf = segue.destination as! TransferViewController
            tf.transferDelegate = self
        } else if segue.identifier == "TarikSegue" {
            let ts = segue.destination as! TarikDuitViewController
            ts.tarikDelegate = self
        } else if segue.identifier == "NabungSegue" {
            let ns = segue.destination as! NabungViewController
            ns.nabungDelegate = self
        } else if segue.identifier == "MasukSegue" {
            let dd = segue.destination as! DapetDuitViewController
            dd.table2Delegate = self
        }
        
    }

}
