//
//  CenterFinderCell.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterFinderCell: UITableViewCell {

    @IBOutlet weak var centerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func confige(center: String){
        centerName.text = center
    }

}
