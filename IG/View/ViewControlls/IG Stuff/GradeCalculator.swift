//
//  GradeCalculator.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class GradeCalculator: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var calculatorTableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
    
    var tableCellsCount = 1
    var gradesArray = [Int]()
    var images = [String]()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        calculatorTableView.delegate = self
        calculatorTableView.dataSource = self
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        self.calculatorTableView.contentInset = insets
        addSubjectBtn()
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "IG Grade Calculator"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func addSubjectBtn() {
        let countryBtn = UIButton()
        countryBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        countryBtn.tintColor = UIColor.white
        countryBtn.setImage(#imageLiteral(resourceName: "addSubject"), for: .normal)
        countryBtn.addTarget(self, action: #selector(addSubjectBtnTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: countryBtn)
    }
    
    @objc func addSubjectBtnTaped() {
        let indexPath = IndexPath.init(row: self.tableCellsCount, section: 0)
        if self.tableCellsCount < 12{
            let index = IndexPath.init(row: (self.tableCellsCount - 1), section: 0)
            let cell = calculatorTableView.cellForRow(at: index) as! calculatorCell
            if cell.isSubjectFill(){
                self.tableCellsCount += 1
                self.calculatorTableView.beginUpdates()
                self.calculatorTableView.insertRows(at: [indexPath], with: .automatic)
                self.calculatorTableView.endUpdates()
                self.viewHeight.constant = CGFloat((80*tableCellsCount) + 280)
                let bottomOffset = CGPoint(x: 0, y: self.calculatorTableView.contentSize.height)
                self.scroll.setContentOffset(bottomOffset, animated: false)
            }else{
                self.showAlert(title: "Add Subject", message: "You must select subject")
            }
        }else{
            self.showAlert(title: "Add Subject", message: "You can't add more than 12 subjects")
        }
    }
    
    func getCellsData() -> [Int] {
        var dataArray: [Int] = []
        for row in 0...tableCellsCount {
            let indexPath = NSIndexPath(row: row, section: 0)
            if let cell = self.calculatorTableView.cellForRow(at: indexPath as IndexPath) as? calculatorCell{
                dataArray.append(cell.getGradeValue())
            }
        }
        print(dataArray)
        return dataArray
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
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let grade = getCellsData()
        var percentageGrade = Float()
        var decemelGrade = Float()
        for n in 0 ..< grade.count {
            percentageGrade += Float(grade[n])
        }
        percentageGrade /= Float(tableCellsCount)
        decemelGrade = (percentageGrade * 410) / 100
        decemelGrade = Float(Double(round(100*decemelGrade)/100))
        percentageGrade = Float(Double(round(100*percentageGrade)/100))
        let vc = UIStoryboard.init(name: "IGStuff", bundle: Bundle.main).instantiateViewController(withIdentifier: "GradeResult") as? GradeResult
        vc?.percentageGrade = percentageGrade
        vc?.decemelGrade = decemelGrade
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension GradeCalculator: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension GradeCalculator: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculatorCell", for: indexPath) as! calculatorCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if self.tableCellsCount != 1{
                self.tableCellsCount -= 1
                self.calculatorTableView.beginUpdates()
                self.calculatorTableView.deleteRows(at: [indexPath], with: .automatic)
                self.calculatorTableView.endUpdates()
            }else{
                self.showAlert(title: "Delete Subject", message: "You can't delete the last one")
            }
        }
    }
}

