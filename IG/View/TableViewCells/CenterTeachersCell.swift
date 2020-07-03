//
//  CenterTeachersCell.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterTeachersCell: UITableViewCell {

    @IBOutlet weak var teacherNameLb: UILabel!
    @IBOutlet weak var teacherLevelsLb: UILabel!
    @IBOutlet weak var teacherSubjectsLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func confige(teacher: TeachersModel){
        var levels = ""
        var subjects = ""
        for n in teacher.levels ?? []{
            levels += "\(n), "
        }
        for n in teacher.subjects ?? []{
            subjects += "\(n), "
        }
        teacherNameLb.text = teacher.name
        teacherLevelsLb.text = levels
        teacherSubjectsLb.text = subjects
    }

}
