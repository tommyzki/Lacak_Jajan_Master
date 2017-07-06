//
//  HistoryDetailsViewController.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/9/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit
import Money

class HistoryDetailsViewController: UIViewController {
    
    var dataHistory: [String: AnyObject]?
    
    @IBOutlet weak var historyDateText: UILabel!
    @IBOutlet weak var historyTimeText: UILabel!
    @IBOutlet weak var historyTypeText: UILabel!
    @IBOutlet weak var historyNominalText: UILabel!
    @IBOutlet weak var historyDeskripsiText: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addBackground()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if ((dataHistory) != nil) {
            
            var rupiah = "0"
            let rupiahTemp: Money = (Money(minorUnits:(dataHistory?["nominal"] as? Int)!))
            rupiah = "\(rupiahTemp)"
            
            historyDateText.text = dataHistory?["date"] as? String
            historyTimeText.text = dataHistory?["time"] as? String
            historyTypeText.text = dataHistory?["type"] as? String
            historyNominalText.text = "\((rupiah))"//.substring(from: rupiah.index(after: rupiah.startIndex )))"
            if ((dataHistory?["desc"] as? String)?.isEmpty)! {
                historyDeskripsiText.text = "Tidak ada Deskripsi"
            } else {
                historyDeskripsiText.text = "Deskripsi: \(dataHistory?["desc"] as? String ?? "")"
            }
            
            var textColor = UIColor(red: 0.063, green: 0.195, blue: 0.128, alpha: 1.0)
            
            switch dataHistory?["type"] as? String {
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
            
            historyTypeText.textColor = textColor
            historyDeskripsiText.textColor = textColor
            historyNominalText.textColor = textColor
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
