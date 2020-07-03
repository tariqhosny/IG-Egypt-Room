//
//  activityRound.swift
//  Go Get It
//
//  Created by Tariq on 10/23/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class activityRound: UIActivityIndicatorView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
