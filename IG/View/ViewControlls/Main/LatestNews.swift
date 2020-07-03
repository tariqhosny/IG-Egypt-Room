//
//  LatestNews.swift
//  IG
//
//  Created by Tariq on 2/13/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class LatestNews: UIViewController {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsLb: UILabel!
    @IBOutlet weak var newsTitleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    var newsData = sliderData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLb.text = newsData.created_at
        newsLb.text = newsData.description?.withoutHtml
        newsTitleLb.text = newsData.title
        loadImage(url: newsData.image ?? "", image: newsImage)
//        addNewsBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Latest News"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func addNewsBtn() {
        let countryBtn = UIButton()
        countryBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        countryBtn.tintColor = UIColor.white
        countryBtn.setImage(#imageLiteral(resourceName: "add news"), for: .normal)
        countryBtn.addTarget(self, action: #selector(addNewsBtnTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: countryBtn)
    }
    
    @objc func addNewsBtnTaped() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "addNews") as? AddNews
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
