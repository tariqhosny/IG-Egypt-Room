//
//  OtherPaperCell.swift
//  IG
//
//  Created by Tariq on 3/15/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class OtherPaperCell: UITableViewCell {

    @IBOutlet weak var fileName: UILabel!
    
    var download: (()->())?
    
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

    @IBAction func downloadPressed(_ sender: UIButton) {
        download?()
    }
}
