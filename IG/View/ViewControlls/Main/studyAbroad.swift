//
//  studyAbroad.swift
//  IG
//
//  Created by Tariq on 2/23/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class StudyAbroad: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var detailsLb: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
    var images = [String]()
    var counter = 1
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        loadStudyAbroad()
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl
        
        startTimer()
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:AnyObject) {
        loadStudyAbroad()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Study Abroad"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadStudyAbroad(){
        self.startIndicator()
        StaticPagesApi.staticPagesApi(staticPages: "StudyAbroads") { (dataError, isSuccess, studyAbroad) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let studyAbroad = studyAbroad?.data{
                        self.titleLb.text = studyAbroad.title
                        self.detailsLb.text = studyAbroad.description?.withoutHtml
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
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
extension StudyAbroad: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configureCell(images: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
