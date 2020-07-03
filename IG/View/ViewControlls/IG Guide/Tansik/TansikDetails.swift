//
//  TansikDetails.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class TansikDetails: UIViewController {
    
    @IBOutlet weak var tansikImage: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var detailsLb: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
    var images = [String]()
    var tansik = TansikData()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLb.text = tansik.name
        detailsLb.text = tansik.description?.withoutHtml
        loadImage(url: tansik.image ?? "", image: tansikImage)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Tansik Guide"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    
}
