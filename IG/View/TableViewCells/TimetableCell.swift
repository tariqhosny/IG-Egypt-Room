//
//  TimetableCell.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class TimetableCell: UITableViewCell {

    @IBOutlet weak var tableName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(table: String){
        tableName.text = table
    }

}
