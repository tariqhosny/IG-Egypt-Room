//
//  TansikGuide.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import SafariServices

class TansikGuide: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tansikTableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
    
    var images = [String]()
    var tansik = TansikTypes()
    var old = [TansikData]()
    var rules = [TansikData]()
    var notes = [TansikData]()
    var counter = 1
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        tansikTableView.delegate = self
        tansikTableView.dataSource = self
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        loadTansik()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        startTimer()
        scroll.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:AnyObject) {
        loadTansik()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tansikTableView.contentSize.height >= view.safeAreaLayoutGuide.layoutFrame.size.height{
            viewHeight.constant = tansikTableView.contentSize.height + 265
        }else{
            viewHeight.constant = view.safeAreaLayoutGuide.layoutFrame.size.height
        }
        
        view.layoutIfNeeded()
        navigationController?.navigationBar.topItem?.title = "Tansik Guide"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadTansik(){
        self.startIndicator()
        TansikApi.tansikApi { (dataError, isSuccess, tansik) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let tansik = tansik{
                        self.tansik = tansik.data!
                    }
                    self.old = self.tansik.old!
                    self.notes = self.tansik.notice!
                    self.rules = self.tansik.rules!
                    self.tansikTableView.reloadData()
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
    
    @IBAction func oldTansikPressed(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "oldTansik") as? OldTansikResults
        vc?.old = self.old
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func tansikOfficePressed(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: NSURL(string: URLs.tansikOffice)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
}

extension TansikGuide: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension TansikGuide: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Rules"
        }else{
            return "Notes"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return rules.count
        }else{
            return notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tansikCell", for: indexPath) as! tansikCell
        cell.selectionStyle = .none
        if indexPath.section == 0{
            cell.configureCell(tansik: rules[indexPath.row].name ?? "")
            return cell
        }else{
            cell.configureCell(tansik: notes[indexPath.row].name ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tansikDetails
        let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "tansikDetails") as? TansikDetails
        if indexPath.section == 0{
            vc?.tansik = self.rules[indexPath.row]
        }else{
            vc?.tansik = self.notes[indexPath.row]
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
