//
//  TeacherFinderCell.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class TeacherFinderCell: UITableViewCell {

    @IBOutlet weak var subjectLb: UILabel!
    @IBOutlet weak var centerNameBtn: UIButton!
    
    var centerTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func confige(center: SubjectAndCenterModel){
        subjectLb.text = center.subject
        centerNameBtn.setTitle(center.center?.name, for: .normal)
    }

    @IBAction func centerBtnPressed(_ sender: UIButton) {
        centerTap?()
    }
}
