//
//  FacebookGroup.swift
//  IG
//
//  Created by Tariq on 2/12/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class FacebookGroup: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var facebookTableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var images = [String]()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        facebookTableView.delegate = self
        facebookTableView.dataSource = self
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if facebookTableView.contentSize.height >= view.safeAreaLayoutGuide.layoutFrame.size.height{
            viewHeight.constant = facebookTableView.contentSize.height + 220
        }else{
            viewHeight.constant = view.safeAreaLayoutGuide.layoutFrame.size.height
        }
        view.layoutIfNeeded()
        navigationController?.navigationBar.topItem?.title = "EIGSR Facebook Group"
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

extension FacebookGroup: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension FacebookGroup: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facebookGroupCell", for: indexPath) as! facebookGroupCell
        if indexPath.row == 0{
            cell.cellTitleLb.text = "EIGSM Group Policy"
        }else if indexPath.row == 1{
            cell.cellTitleLb.text = "Suggestions & Complaints"
        }else{
            cell.cellTitleLb.text = "Ban Removal Request"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "toPolicies", sender: self)
        }else if indexPath.row == 1{
            performSegue(withIdentifier: "toSuggestions", sender: self)
        }else{
            performSegue(withIdentifier: "toBanRemover", sender: self)
        }
    }
}
