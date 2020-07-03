//
//  BannerCell.swift
//  IG
//
//  Created by Tariq on 2/6/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    func configureCell(images: String){
        let urlWithoutEncoding = ("\(images)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        bannerImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            bannerImage.kf.setImage(with: url)
        }
    }
    
}
