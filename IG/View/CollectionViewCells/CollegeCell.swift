//
//  CollegeCell.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CollegeCell: UICollectionViewCell {
    
    @IBOutlet weak var collegeNameLb: UILabel!
    
    func confige(college: String){
        collegeNameLb.text = college
    }
}
