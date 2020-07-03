//
//  TeacherInfo.swift
//  FruitInn
//
//  Created by Tariq on 12/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class TeacherInfo: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var levelsLb: UILabel!
    @IBOutlet weak var collegeCollectionView: UICollectionView!
    
    var info = [TeacherFinderData]()
    var college = [String]()
    var levels = String()
    var section = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        popView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPop(_:))))
        
        collegeCollectionView.delegate = self
        collegeCollectionView.dataSource = self
        
        nameLb.text = info[section].teacherData?.name
        phoneLb.text = info[section].teacherData?.phone
        for n in info[section].levels ?? []{
            levels += "\(n), "
        }
        levelsLb.text = levels
        college = info[section].colleges ?? []
        // Do any additional setup after loading the view.
    }
    
    
    @objc func onTap(_ sender:UIPanGestureRecognizer) {
       dismiss(animated: false, completion: nil)
    }
    
    @objc func onTapPop(_ sender:UIPanGestureRecognizer) {
        print("")
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
extension TeacherInfo: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return college.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCell", for: indexPath) as! CollegeCell
        cell.confige(college: college[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collegeCollectionView.dataSource?.collectionView(collegeCollectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }
        
        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset
        
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collegeCollectionView.frame.size.width - collegeCollectionView.contentInset.left - collegeCollectionView.contentInset.right
        
        guard totalCellWidth < contentWidth else {
            return insets
        }
        
        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
    }
}
