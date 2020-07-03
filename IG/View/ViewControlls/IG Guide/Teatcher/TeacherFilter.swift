//
//  TeacherFilter.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class TeacherFilter: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var countryTf: UITextField!
    @IBOutlet weak var subjectsTf: UITextField!
    @IBOutlet weak var centersTf: UITextField!
    
    let subjectsPickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    let areaPickerView = UIPickerView()
    let centerPickerView = UIPickerView()
    
    var subjects = [SubjectsData]()
    var countries = [SubjectsData]()
    var centers = [CenterData]()
    var teachers = [TeacherFinderData]()
    var images = [String]()
    var centerId = Int()
    var subjectId = Int()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        subjectsPickerView.delegate = self
        subjectsPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        areaPickerView.delegate = self
        areaPickerView.dataSource = self
        centerPickerView.delegate = self
        centerPickerView.dataSource = self
        
        subjectsTf.inputView = subjectsPickerView
        countryTf.inputView = countryPickerView
        centersTf.inputView = centerPickerView
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        
        loadSubjects()
        loadCountries()
        addTeacherBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Teacher Finder"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func addTeacherBtn() {
        let countryBtn = UIButton()
        countryBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        countryBtn.tintColor = UIColor.white
        countryBtn.setImage(#imageLiteral(resourceName: "add teacher"), for: .normal)
        countryBtn.addTarget(self, action: #selector(addTeacherBtnTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: countryBtn)
    }
    
    @objc func addTeacherBtnTaped() {
        let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "addTeacher") as? AddTeacher
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func loadSubjects(){
        self.startIndicator()
        PapersAPIs.allSubjectsApi{ (dataError, isSuccess, subject) in
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
    
    func loadCountries(){
        self.startIndicator()
        CountriesAPIs.countriesApi{ (dataError, isSuccess, countries) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let countries = countries?.data{
                        self.countries = countries
                        self.countryPickerView.reloadAllComponents()
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
    func loadCenters(countryId: Int){
        self.startIndicator()
        SchoolsAPIs.centersByCountryApi(countryId: countryId){ (dataError, isSuccess, centers) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let centers = centers?.data{
                        self.centers = centers
                        self.centerPickerView.reloadAllComponents()
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
        self.startIndicator()
        SchoolsAPIs.teachersApi(subjectId: subjectId, centerId: centerId) { (dataError, isSuccess, teachers) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let teachers = teachers?.data{
                        if teachers.count == 0{
                            self.showAlert(title: "Teacher", message: "No Teachers found")
                        }else{
                            let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeacherFinder") as? TeacherFinder
                            vc?.teachers = teachers
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
extension TeacherFilter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension TeacherFilter: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == subjectsPickerView{
            return subjects.count
        }else if pickerView == countryPickerView{
            return countries.count
        }else{
            return centers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == subjectsPickerView{
            return subjects[row].name
        }else if pickerView == countryPickerView{
            return countries[row].name
        }else{
            return centers[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == subjectsPickerView{
            if subjects.count != 0 {
                self.subjectsTf.text = subjects[row].name
                self.subjectId = subjects[row].id ?? 0
            }
        }else if pickerView == countryPickerView{
            if countries.count != 0 {
                self.countryTf.text = countries[row].name
                self.loadCenters(countryId: countries[row].id ?? 0)
            }
        }else{
            if centers.count != 0 {
                self.centersTf.text = centers[row].name
                self.centerId = centers[row].id ?? 0
            }
        }
    }
}
