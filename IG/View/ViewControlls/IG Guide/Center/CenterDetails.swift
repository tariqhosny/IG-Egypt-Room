//
//  CenterDetails.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterDetails: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var centerNameLb: UILabel!
    @IBOutlet weak var centerPhoneLb: UILabel!
    @IBOutlet weak var centerAddressLb: UILabel!
    @IBOutlet weak var centerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var centerDetailsLb: UILabel!
    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var center = CenterData()
    var images = [ImagesModel]()
    var teachers = [TeachersModel]()
    var cellHeight = CGFloat()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewData()
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        teachersTableView.delegate = self
        teachersTableView.dataSource = self
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDetailsView()
        navigationController?.navigationBar.topItem?.title = "Center Details"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadViewData(){
        images = center.images ?? []
        centerNameLb.text = center.name
        centerPhoneLb.text = center.phone
        centerAddressLb.text = center.address
        centerDetailsLb.text = center.description
        teachers = center.teachers ?? []
        teachersTableView.reloadData()
        teachersTableView.isHidden = true
    }
    
    func loadDetailsView(){
        teachersTableView.isHidden = true
        centerDetailsLb.isHidden = false
        viewHeight.constant = 410 + centerDetailsLb.frame.size.height + centerAddressLb.frame.size.height
        view.layoutIfNeeded()
    }
    
    func loadTeacherView(){
        teachersTableView.isHidden = false
        centerDetailsLb.isHidden = true
        viewHeight.constant = 410 + cellHeight + centerAddressLb.frame.size.height
        view.layoutIfNeeded()
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
    
    @IBAction func centerSegmentedChoised(_ sender: UISegmentedControl) {
        switch centerSegmentedControl.selectedSegmentIndex {
        case 0:
            loadDetailsView()
        case 1:
            loadTeacherView()
        default:
            print("AnyThing")
        }
    }
    
}
extension CenterDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configureCell(images: images[indexPath.item].image ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension CenterDetails: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTeachersCell", for: indexPath) as! CenterTeachersCell
        cell.selectionStyle = .none
        cellHeight += cell.frame.height
        cell.confige(teacher: teachers[indexPath.row])
        return cell
    }
}
