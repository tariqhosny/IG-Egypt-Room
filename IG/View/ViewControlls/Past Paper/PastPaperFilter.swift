//
//  PastPaperFilter.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class PastPaperFilter: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var levelTf: UITextField!
    @IBOutlet weak var universityTf: UITextField!
    @IBOutlet weak var subjectsTf: UITextField!
    @IBOutlet weak var sessionTf: UITextField!
    @IBOutlet weak var yearTf: UITextField!
    
    let levelsPickerView = UIPickerView()
    let subjectsPickerView = UIPickerView()
    let universityPickerView = UIPickerView()
    let sessionPickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    
    var subjects = [SubjectsData]()
    var data = fixedData()
    var images = [String]()
    var paperType = String()
    var screenName = String()
    var subjectCode = String()
    var year = String()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
        universityPickerView.delegate = self
        universityPickerView.dataSource = self
        subjectsPickerView.delegate = self
        subjectsPickerView.dataSource = self
        sessionPickerView.delegate = self
        sessionPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        levelTf.inputView = levelsPickerView
        subjectsTf.inputView = subjectsPickerView
        universityTf.inputView = universityPickerView
        sessionTf.inputView = sessionPickerView
        yearTf.inputView = yearPickerView
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = screenName
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadSubjects(){
        guard let college = universityTf.text, !college.isEmpty else {
            let messages = "Please enter your college to load subjects"
            self.showAlert(title: "Subject", message: messages)
            return
        }
        
        guard let level = levelTf.text, !level.isEmpty else {
            let messages = "Please enter your level to load subjects"
            self.showAlert(title: "Subject", message: messages)
            return
        }
        self.startIndicator()
        PapersAPIs.subjectsApi(college: college, level: level) { (dataError, isSuccess, subject) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let subject = subject?.data{
                        self.subjects = subject
                        self.subjectsPickerView.reloadAllComponents()
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
    
    @IBAction func searchPressed(_ sender: UIButton) {
        guard let level = levelTf.text, !level.isEmpty else {
            let messages = "Please enter your level"
            self.showAlert(title: "Paper", message: messages)
            return
        }
        guard let college = universityTf.text, !college.isEmpty else {
            let messages = "Please enter your college"
            self.showAlert(title: "Paper", message: messages)
            return
        }
        guard let subjects = subjectsTf.text, !subjects.isEmpty else {
            let messages = "Please enter your subjects"
            self.showAlert(title: "Paper", message: messages)
            return
        }
        guard let session = sessionTf.text, !session.isEmpty else {
            let messages = "Please enter session"
            self.showAlert(title: "Paper", message: messages)
            return
        }
        guard let year = yearTf.text, !year.isEmpty else {
            let messages = "Please enter year"
            self.showAlert(title: "Paper", message: messages)
            return
        }
        
        print(paperType)
        print(subjectCode)
        print(level)
        print(college)
        print(session)
        print(self.year)
        
        if paperType == "qp"{
            let vc = UIStoryboard.init(name: "PastPaper", bundle: Bundle.main).instantiateViewController(withIdentifier: "pastPapers") as? PastPapersQuestions
            vc?.paperType = paperType
            vc?.subjectCode = subjectCode
            vc?.year = self.year
            vc?.level = level
            vc?.college = college
            vc?.session = session
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            self.startIndicator()
            PapersAPIs.otherPaperApi(college: college, level: level, year: self.year, session: session, subjectCode: subjectCode, paperType: paperType, variantName: "") { (dataError, isSuccess, papers) in
                if dataError!{
                    print("data error")
                    self.stopAnimating()
                }else{
                    if isSuccess!{
                        if let paper = papers?.data{
                            if paper.count == 0{
                                self.showAlert(title: "Teacher", message: "No Files Found")
                            }else{
                                let vc = UIStoryboard.init(name: "PastPaper", bundle: Bundle.main).instantiateViewController(withIdentifier: "otherPaper") as? OtherPaperPage
                                vc?.paper = paper
                                vc?.screenName = self.screenName
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }
                        self.stopAnimating()
                    }else{
                        self.showAlert(title: "Connection", message: "Please check your internet connection")
                        self.stopAnimating()
                    }
                }
            }
        }
    }
    
}
extension PastPaperFilter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
extension PastPaperFilter: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelsPickerView{
            return data.levels.count
        }else if pickerView == subjectsPickerView{
            return subjects.count
        }else if pickerView == sessionPickerView{
            return data.sessions.count
        }else if pickerView == yearPickerView{
            return data.years.count
        }else{
            return data.college.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelsPickerView{
            return data.levels[row]
        }else if pickerView == subjectsPickerView{
            return subjects[row].name
        }else if pickerView == sessionPickerView{
            return data.sessions[row]
        }else if pickerView == yearPickerView{
            return data.years[row]
        }else{
            return data.college[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelsPickerView{
            self.levelTf.text = data.levels[row]
            self.loadSubjects()
        }else if pickerView == subjectsPickerView{
            if subjects.count != 0 {
                self.subjectsTf.text = subjects[row].name
                self.subjectCode = subjects[row].code ?? ""
            }
        }else if pickerView == sessionPickerView{
            self.sessionTf.text = data.sessions[row]
        }else if pickerView == yearPickerView{
            self.yearTf.text = data.years[row]
            self.year = String(data.years[row].suffix(2))
            print(self.year)
        }else{
            self.universityTf.text = data.college[row]
            self.loadSubjects()
        }
    }
}
