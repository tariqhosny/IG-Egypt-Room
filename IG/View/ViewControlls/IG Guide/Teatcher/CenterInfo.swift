//
//  CenterInfo.swift
//  IG
//
//  Created by Tariq on 3/19/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterInfo: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    
    var info = SubjectCentersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        popView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPop(_:))))
        
        nameLb.text = info.name
        phoneLb.text = info.phone
        addressLb.text = info.address
        emailLb.text = info.email
        // Do any additional setup after loading the view.
    }
    
    
    @objc func onTap(_ sender:UIPanGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func onTapPop(_ sender:UIPanGestureRecognizer) {
        print("")
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
