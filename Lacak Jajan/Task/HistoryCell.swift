//
//  HistoryCell.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 5/29/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    
    @IBOutlet weak var typeTransactText: UILabel!
    
    @IBOutlet weak var nominalTransactText: UILabel!
    
    @IBOutlet weak var dateTransactText: UILabel!

    @IBOutlet weak var timeTransactText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
