//
//  SchoolFinderCell.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class SchoolFinderCell: UITableViewCell {

    @IBOutlet weak var schoolNameLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var areaLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(school: SchoolsData){
        schoolNameLb.text = school.name
        addressLb.text = school.address
        phoneLb.text = school.phone
        emailLb.text = school.email
        areaLb.text = "\(school.city ?? ""), \(school.state ?? "")"
    }

}
