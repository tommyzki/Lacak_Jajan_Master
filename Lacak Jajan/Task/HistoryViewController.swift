//
//  HistoryViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 5/29/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import SVProgressHUD
import Money

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let historyzat = Historys()

    @IBOutlet weak var tableViewCons: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let username = UserDefaults.standard.object(forKey: "userzat") as! String
        
        historyzat.loadHistory(loginusername: username, completed: {
            (success) -> Void in
            SVProgressHUD.dismiss()
            
            if success { // this will be equal to whatever value is set in this method call
                self.tableViewCons.reloadData()
            } else {
                self.showAlert("Gagal Load Data", title: "Error")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.historyzat.dictData[0]["nominal"] as? Int {
            return self.historyzat.dictData.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCells", for: indexPath) as! HistoryCell
        var rupiah = "0"
        if let nominal = self.historyzat.dictData[indexPath.row]["nominal"] as? Int {
            
            
            let rupiahTemp: Money = (Money(nominal))
            rupiah = "\(rupiahTemp)"
            
            cell.nominalTransactText.text = "\((rupiah))"//.substring(from: rupiah.index(after: rupiah.startIndex )))"
            cell.dateTransactText.text = self.historyzat.dictData[indexPath.row]["date"] as? String
            cell.timeTransactText.text = self.historyzat.dictData[indexPath.row]["time"] as? String
            cell.typeTransactText.text = self.historyzat.dictData[indexPath.row]["type"] as? String
            
            var textColor = UIColor(red: 0.063, green: 0.195, blue: 0.128, alpha: 1.0)
            
            switch self.historyzat.dictData[indexPath.row]["type"] as? String {
            case "Tarik Duit"?:
                textColor = UIColor(red: 0.074, green: 0.074, blue: 0.074, alpha: 1.0)
            case "Nabung"?:
                textColor = UIColor(red: 0.074, green: 0.074, blue: 0.074, alpha: 1.0)
            case "Transfer"?:
                textColor = UIColor(red: 0.216, green: 0.043, blue: 0.030, alpha: 1.0)
            case "Jajan"?:
                textColor = UIColor(red: 0.216, green: 0.043, blue: 0.030, alpha: 1.0)
            default:
                textColor = UIColor(red: 0.063, green: 0.195, blue: 0.128, alpha: 1.0)
            }
            
            cell.nominalTransactText.textColor = textColor
            cell.typeTransactText.textColor = textColor
            
        } else {
            //self.showAlert("History Masih Kosong, Lakukan Transaksi", title: "Error")
            cell.nominalTransactText.text = ""
            cell.dateTransactText.text = ""
            cell.timeTransactText.text = ""
            cell.typeTransactText.text = ""
        }
        
        return cell
        
    }
    
    // MARK: - Table View Delegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "toDetailsSegue", sender: indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let myIndexPath = sender as! IndexPath
        
        if let detailsViewController = segue.destination as? HistoryDetailsViewController {
            
            detailsViewController.title = self.historyzat.dictData[myIndexPath.row]["type"] as? String
            detailsViewController.dataHistory = self.historyzat.dictData[myIndexPath.row]
            
        }
    }
}
