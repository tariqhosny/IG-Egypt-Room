//
//  TeacherFinder.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class TeacherFinder: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var images = [String]()
    var teachers = [TeacherFinderData]()
    var subjectesCount = Int()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        teachersTableView.delegate = self
        teachersTableView.dataSource = self
        teachersTableView.sectionHeaderHeight = 40
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Teacher Finder"
        print(teachers.count)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc func teacherInfoTap(sender: UIButton) {
        let vc = UIStoryboard(name: "IGGuide", bundle: nil)
        let popUp = vc.instantiateViewController(withIdentifier: "TeacherInfo") as! TeacherInfo
        popUp.info = teachers
        popUp.section = sender.tag
        self.present(popUp, animated: false)
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

extension TeacherFinder: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension TeacherFinder: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))

        let teacherName = UIButton()
        teacherName.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width/2, height: headerView.frame.height)
        teacherName.setTitle(teachers[section].teacherData?.name ?? "", for: .normal)
        teacherName.addTarget(self, action: #selector(teacherInfoTap(sender:)), for: .touchUpInside)
        teacherName.tag = section
        teacherName.setTitleColor(#colorLiteral(red: 0.4722354578, green: 0.7734761834, blue: 0.4491385137, alpha: 1), for: .normal)
        headerView.addSubview(teacherName)
        headerView.backgroundColor = #colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subjectesCount = teachers[section].subjectAndCenter?.count ?? 0
        return subjectesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherFinderCell", for: indexPath) as! TeacherFinderCell
        cell.selectionStyle = .none
        cell.centerTap = {
            let vc = UIStoryboard(name: "IGGuide", bundle: nil)
            let popUp = vc.instantiateViewController(withIdentifier: "CenterInfo") as! CenterInfo
            popUp.info = (self.teachers[indexPath.section].subjectAndCenter?[indexPath.row].center)!
            self.present(popUp, animated: false)
        }
        cell.confige(center: (teachers[indexPath.section].subjectAndCenter?[indexPath.row])!)
        return cell
    }
}
