//
//  IGStuff.swift
//  IG
//
//  Created by Tariq on 2/12/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import SafariServices

class IGStuff: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var stuffCategoriesCollectionView: UICollectionView!
    
    var images = [String]()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        stuffCategoriesCollectionView.delegate = self
        stuffCategoriesCollectionView.dataSource = self
        
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "IG Stuff"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        if counter < images.count {
            let index = IndexPath.init(item: counter, section: 0)
            pageControl.currentPage = counter
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        }else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            pageControl.currentPage = counter
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter = 1
        }
    }
    
}
extension IGStuff: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView{
            return images.count
        }else{
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configureCell(images: images[indexPath.item])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionsCell", for: indexPath) as! SectionsCell
            if indexPath.item == 0{
                cell.sectionImage.image = #imageLiteral(resourceName: "facebook")
                cell.sectionName.text = "EIGRS Facebook Group"
                gradientColors(color1: #colorLiteral(red: 0, green: 0.3725490196, blue: 0.5019607843, alpha: 1), color2: #colorLiteral(red: 0.02352941176, green: 0.5176470588, blue: 0.6784313725, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 1{
                cell.sectionImage.image = #imageLiteral(resourceName: "calculator")
                cell.sectionName.text = "IG Grade Calculator"
                gradientColors(color1: #colorLiteral(red: 0.7874826878, green: 0.6766592382, blue: 0.1568627451, alpha: 1), color2: #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 2{
                cell.sectionImage.image = #imageLiteral(resourceName: "agent")
                cell.sectionName.text = "Private For All"
                gradientColors(color1: #colorLiteral(red: 0.5843137255, green: 0.9058823529, blue: 0.4823529412, alpha: 1), color2: #colorLiteral(red: 0.2941176471, green: 0.6745098039, blue: 0.8, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 3{
                cell.sectionImage.image = #imageLiteral(resourceName: "IELTS_logo.svg")
                cell.sectionName.text = "IELTS Course Registration"
                gradientColors(color1: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), color2: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), cell: cell.contentView)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bannerCollectionView{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else{
            return CGSize.init(width: collectionView.frame.size.width, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == stuffCategoriesCollectionView{
            if indexPath.item == 0{
                performSegue(withIdentifier: "toFacebookGroup", sender: self)
            }else if indexPath.item == 1{
                performSegue(withIdentifier: "toCalculator", sender: self)
            }else if indexPath.item == 2{
                let vc = UIStoryboard.init(name: "IGStuff", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivateForAll") as? PrivateForAll
                vc?.isPrivate = true
                vc?.pageTitle = "Private For All"
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                let vc = UIStoryboard.init(name: "IGStuff", bundle: Bundle.main).instantiateViewController(withIdentifier: "PrivateForAll") as? PrivateForAll
                vc?.isPrivate = false
                vc?.pageTitle = "Login"
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
}
