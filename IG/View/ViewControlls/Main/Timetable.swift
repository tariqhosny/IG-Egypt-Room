//
//  Timetable.swift
//  IG
//
//  Created by Tariq on 2/13/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class Timetable: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var timetablesTableView: UITableView!
    @IBOutlet weak var universitiesSC: UISegmentedControl!
    
    var pdfURL = String()
    var images = [String]()
    var counter = 1
    var tables = TimetableUniversities()
    var universityTables = [UniversitiesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        timetablesTableView.delegate = self
        timetablesTableView.dataSource = self
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        loadTables()
        startTimer()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Timetable"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadTables(){
        self.startIndicator()
        TimetableApi.timetableApi { (dataError, isSuccess, tables) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let tables = tables{
                        self.tables = tables.data!
                    }
                    self.universityTables = self.tables.cambridge!
                    self.timetablesTableView.reloadData()
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
    
    @IBAction func universitiesSCPressed(_ sender: UISegmentedControl) {
        switch universitiesSC.selectedSegmentIndex {
        case 0:
            self.universityTables = self.tables.cambridge ?? []
            self.timetablesTableView.reloadData()
        case 1:
            self.universityTables = self.tables.edexcel ?? []
            self.timetablesTableView.reloadData()
        case 2:
            self.universityTables = self.tables.oxford ?? []
            self.timetablesTableView.reloadData()
        default:
            print("AnyThing")
        }
    }
    
}
extension Timetable: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension Timetable: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universityTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableCell", for: indexPath) as! TimetableCell
        cell.configureCell(table: universityTables[indexPath.row].name ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.pdfURL = universityTables[indexPath.row].file ?? ""
        storeAndShare(withURLString: pdfURL)
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pdfViewer") as? PDFViewer
//        vc?.pdfURL = URL(string: self.pdfURL)
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
