//
//  PastPaperQuestionsCell.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class PastPaperQuestionsCell: UITableViewCell {

    @IBOutlet weak var fileName: UILabel!
    
    func configureCell(name: String){
        fileName.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
