//
//  NewsCell.swift
//  IG
//
//  Created by Tariq on 2/6/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsName: UILabel!
    
    func configureCell(news: sliderData){
        newsDate.text = news.created_at
        newsName.text = news.title
        let urlWithoutEncoding = ("\(news.image ?? "")")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        newsImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            newsImage.kf.setImage(with: url)
        }
    }
    
}
