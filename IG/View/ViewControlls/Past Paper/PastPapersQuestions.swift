//
//  PastPapersQuestions.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class PastPapersQuestions: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var questionSegmetedControl: UISegmentedControl!
    @IBOutlet weak var papersTableView: UITableView!
    
    var papers = [paperList]()
    var subjects = [SubjectsData]()
    var data = fixedData()
    var images = [String]()
    var paperType = String()
    var subjectCode = String()
    var year = String()
    var level = String()
    var college = String()
    var session = String()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        papersTableView.delegate = self
        papersTableView.dataSource = self
        
        loadPapers(paperType: paperType)
        
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Past Papers"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadPapers(paperType: String){
        self.startIndicator()
        PapersAPIs.pastPaperApi(college: college, level: level, year: self.year, session: session, subjectCode: subjectCode, paperType: paperType, variantName: "") { (dataError, isSuccess, papers) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let paper = papers?.data{
                        self.papers = paper
                        self.papersTableView.reloadData()
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
    
    @IBAction func papersSegmentedControl(_ sender: UISegmentedControl) {
        switch questionSegmetedControl.selectedSegmentIndex {
        case 0:
            self.loadPapers(paperType: "qp")
        case 1:
            self.loadPapers(paperType: "ms")
        default:
            print("AnyThing")
        }
    }

}
extension PastPapersQuestions: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension PastPapersQuestions: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return papers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Paper \(papers[section].paper ?? "")"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return papers[section].files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastPaperQuestionsCell", for: indexPath) as! PastPaperQuestionsCell
        cell.selectionStyle = .none
        cell.configureCell(name: papers[indexPath.section].files?[indexPath.row].fileName ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfURL = papers[indexPath.section].files?[indexPath.row].file ?? ""
        storeAndShare(withURLString: pdfURL)
    }
}
