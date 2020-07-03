//
//  IGGuide.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class IGGuide: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var guideCategoriesCollectionView: UICollectionView!
    
    var images = [String]()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        guideCategoriesCollectionView.delegate = self
        guideCategoriesCollectionView.dataSource = self
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "IG Guide"
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
extension IGGuide: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView{
            return images.count
        }else{
            return 5
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
                cell.sectionImage.image = #imageLiteral(resourceName: "egigstudentroomFinalLogowithoutweb")
                cell.sectionName.text = "About IG"
                gradientColors(color1: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), color2: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 1{
                cell.sectionImage.image = #imageLiteral(resourceName: "teacher")
                cell.sectionName.text = "Teacher Finder"
                gradientColors(color1: #colorLiteral(red: 0, green: 0.3725490196, blue: 0.5019607843, alpha: 1), color2: #colorLiteral(red: 0.02352941176, green: 0.5176470588, blue: 0.6784313725, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 2{
                cell.sectionImage.image = #imageLiteral(resourceName: "published")
                cell.sectionName.text = "Center Finder"
                gradientColors(color1: #colorLiteral(red: 0.968627451, green: 0.4941176471, blue: 0.1764705882, alpha: 1), color2: #colorLiteral(red: 0.9176470588, green: 0.6431372549, blue: 0.4392156863, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 3{
                cell.sectionImage.image = #imageLiteral(resourceName: "stuff")
                cell.sectionName.text = "Egypt IG School Finder"
                gradientColors(color1: #colorLiteral(red: 0.7874826878, green: 0.6766592382, blue: 0.1568627451, alpha: 1), color2: #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 4{
                cell.sectionImage.image = #imageLiteral(resourceName: "guide")
                cell.sectionName.text = "Tansik Guide"
                gradientColors(color1: #colorLiteral(red: 0.5843137255, green: 0.9058823529, blue: 0.4823529412, alpha: 1), color2: #colorLiteral(red: 0.2941176471, green: 0.6745098039, blue: 0.8, alpha: 1), cell: cell.contentView)
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
        if collectionView == guideCategoriesCollectionView{
            if indexPath.item == 0{
               let vc = UIStoryboard.init(name: "IGStuff", bundle: Bundle.main).instantiateViewController(withIdentifier: "GroupPolicy") as? GroupPolicy
               vc?.isPolicyPage = false
               self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 1{
               performSegue(withIdentifier: "toFilterTeacher", sender: self)
            }else if indexPath.item == 2{
                performSegue(withIdentifier: "toFilterCenter", sender: self)
            }else if indexPath.item == 3{
                performSegue(withIdentifier: "toFilterSchool", sender: self)
            }else{
                performSegue(withIdentifier: "toTansikGuide", sender: self)
            }
        }
    }
}
