//
//  Home.swift
//  IG
//
//  Created by Tariq on 2/6/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sectionsCollectionView: UICollectionView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var rightScollBannerBtn: UIButton!
    @IBOutlet weak var leftScrollBannerBtn: UIButton!
    
    var slider = [sliderData]()
    var images = [String]()
    var news = [sliderData]()
    var counter = 1
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        sectionsCollectionView.delegate = self
        sectionsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        addTitleImage()
        sliderHandel()
        loadNews()
        startTimer()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender:AnyObject) {
        sliderHandel()
        loadNews()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewHeightCalc()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func sliderHandel(){
        self.startIndicator()
        sliderApi.sliderApi { (dataError, isSuccess, image) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let images = image?.data{
                        self.slider = images
                        print(self.slider)
                        sliderResponse.saveSlider(slider: self.slider)
                        self.images = self.sliderHandelRefresh(bannerCollectionView: self.bannerCollectionView, pageControl: self.pageControl)
                        self.bannerScroll(rightBtn: self.rightScollBannerBtn, leftBtn: self.leftScrollBannerBtn)
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
    func loadNews(){
        self.startIndicator()
        NewsApi.newsApi { (dataError, isSuccess, news) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let news = news?.data{
                        self.news = news
                        self.newsCollectionView.reloadData()
                    }
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
    func viewHeightCalc(){
        let collectionsHeight = self.sectionsCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.viewHeight.constant = collectionsHeight + 470
    }
    
    func bannerScroll(rightBtn: UIButton, leftBtn: UIButton){
        if counter == 1 {
            leftScrollBannerBtn.isHidden = true
        }
        rightBtn.addTarget(self, action: #selector(rightBtnTap(sender:)), for: .touchUpInside)
        leftBtn.addTarget(self, action: #selector(leftBtnTap(sender:)), for: .touchUpInside)
    }
    
    @objc func leftBtnTap(sender: UIButton) {
        rightScollBannerBtn.isHidden = false
        let index = IndexPath.init(item: (counter - 2), section: 0)
        bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = counter
        if counter == 0 {
            sender.isHidden = true
            counter += 2
        }
        counter -= 1
    }
    
    @objc func rightBtnTap(sender: UIButton) {
        leftScrollBannerBtn.isHidden = false
        let index = IndexPath.init(item: counter, section: 0)
        bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = counter
        counter += 1
        if counter == images.count {
            sender.isHidden = true
        }
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
extension Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView{
            return images.count
        }else if collectionView == newsCollectionView{
            return news.count
        }else{
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configureCell(images: images[indexPath.item])
            return cell
        }else if collectionView == sectionsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionsCell", for: indexPath) as! SectionsCell
            if indexPath.item == 0{
                cell.sectionImage.image = #imageLiteral(resourceName: "guide")
                cell.sectionName.text = "IG Guide"
                gradientColors(color1: #colorLiteral(red: 0, green: 0.3725490196, blue: 0.5019607843, alpha: 1), color2: #colorLiteral(red: 0.02352941176, green: 0.5176470588, blue: 0.6784313725, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 1{
                cell.sectionImage.image = #imageLiteral(resourceName: "pastPapers")
                cell.sectionName.text = "Past Papers"
                gradientColors(color1: #colorLiteral(red: 0.5294117647, green: 0.7529411765, blue: 0.4352941176, alpha: 1), color2: #colorLiteral(red: 0.6901960784, green: 0.9607843137, blue: 0.6352941176, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 2{
                cell.sectionImage.image = #imageLiteral(resourceName: "stuff")
                cell.sectionName.text = "IG Stuff"
                gradientColors(color1: #colorLiteral(red: 0.7874826878, green: 0.6766592382, blue: 0.1568627451, alpha: 1), color2: #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 3{
                cell.sectionImage.image = #imageLiteral(resourceName: "studyAbroad")
                cell.sectionName.text = "Study Abroad"
                gradientColors(color1: #colorLiteral(red: 0.968627451, green: 0.4941176471, blue: 0.1764705882, alpha: 1), color2: #colorLiteral(red: 0.9176470588, green: 0.6431372549, blue: 0.4392156863, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 4{
                cell.sectionImage.image = #imageLiteral(resourceName: "timetables")
                cell.sectionName.text = "Timetables"
                gradientColors(color1: #colorLiteral(red: 0.5843137255, green: 0.9058823529, blue: 0.4823529412, alpha: 1), color2: #colorLiteral(red: 0.2941176471, green: 0.6745098039, blue: 0.8, alpha: 1), cell: cell.contentView)
            }else if indexPath.item == 5{
                cell.sectionImage.image = #imageLiteral(resourceName: "examination")
                cell.sectionName.text = "Contact Us"
                gradientColors(color1: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), color2: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), cell: cell.contentView)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
            cell.configureCell(news: news[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bannerCollectionView{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }else if collectionView == sectionsCollectionView{
            if indexPath.item == 4 || indexPath.item == 5{
                return CGSize.init(width: collectionView.frame.size.width, height: 120)
            }else{
                let screenWidth = collectionView.frame.width
                var width = (screenWidth-10)/2
                width = width < 130 ? 160 : width
                return CGSize.init(width: width, height: 120)
            }
        }else{
            let screenWidth = collectionView.frame.width
            var width = (screenWidth-10)/2.25
            width = width < 130 ? 160 : width
            return CGSize.init(width: width, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sectionsCollectionView{
            if indexPath.item == 0{
                //            "IG Guide"
                let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "IGGuide") as? IGGuide
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 1{
                //            "Past Papers"
                let vc = UIStoryboard.init(name: "PastPaper", bundle: Bundle.main).instantiateViewController(withIdentifier: "pastPaperCategories") as? PastPaperCategories
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 2{
                //            "IGStuff"
                let vc = UIStoryboard.init(name: "IGStuff", bundle: Bundle.main).instantiateViewController(withIdentifier: "IGStuff") as? IGStuff
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 3{
                //            "studyAbroad"
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "studyAbroad") as? StudyAbroad
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 4{
                //            "timetable"
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "timetable") as? Timetable
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.item == 5{
                //            "timetable"
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactUs") as? ContactUs
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else if collectionView == newsCollectionView{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "news") as? LatestNews
            vc?.newsData = news[indexPath.item]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var count = 0
        if scrollView.tag == 1{
            count = Int(scrollView.contentOffset.x / bannerCollectionView.frame.size.width)
            pageControl.currentPage = count
            if count == 0 {
                leftScrollBannerBtn.isHidden = true
            }else{
                leftScrollBannerBtn.isHidden = false
            }
            if count == (images.count - 1){
                rightScollBannerBtn.isHidden = true
            }else{
                rightScollBannerBtn.isHidden = false
            }
        }
    }
}
