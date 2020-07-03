//
//  oldTansikCell.swift
//  IG
//
//  Created by Tariq on 3/1/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class oldTansikCell: UITableViewCell {
    
    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(tansik: String){
        titleLb.text = tansik
    }

}
