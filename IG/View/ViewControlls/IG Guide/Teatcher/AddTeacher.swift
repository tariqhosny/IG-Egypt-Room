//
//  AddTeacher.swift
//  IG
//
//  Created by Tariq on 2/10/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class AddTeacher: UIViewController {
    
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var countryTf: UITextField!
    @IBOutlet weak var subjectTf: UITextField!
    @IBOutlet weak var universityTf: UITextField!
    @IBOutlet weak var levelTf: UITextField!
    @IBOutlet weak var centerNameTf: UITextField!
    
    let levelsPickerView = UIPickerView()
    let subjectsPickerView = UIPickerView()
    let collegePickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    let titlePickerView = UIPickerView()
    let centerPickerView = UIPickerView()
    
    var subjects = [SubjectsData]()
    var countries = [SubjectsData]()
    var centers = [CenterData]()
    var countryId = Int()
    var centerId = Int()
    var subjectId = Int()
    let data = fixedData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
        collegePickerView.delegate = self
        collegePickerView.dataSource = self
        subjectsPickerView.delegate = self
        subjectsPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        titlePickerView.delegate = self
        titlePickerView.dataSource = self
        centerPickerView.delegate = self
        centerPickerView.dataSource = self
        
        levelTf.inputView = levelsPickerView
        subjectTf.inputView = subjectsPickerView
        universityTf.inputView = collegePickerView
        countryTf.inputView = countryPickerView
        titleTf.inputView = titlePickerView
        centerNameTf.inputView = centerPickerView
        
        loadCountries()
        loadSubjects()
        loadCenters()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Add Teacher"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
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
    
    func loadCenters(){
        self.startIndicator()
        SchoolsAPIs.allCentersApi{ (dataError, isSuccess, centers) in
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
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let title = titleTf.text, !title.isEmpty else {
            let messages = "Please select your title"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let name = nameTf.text, !name.isEmpty else {
            let messages = "Please enter your name"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let phone = phoneTf.text, !phone.isEmpty else {
            let messages = "Please enter your phone"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let country = countryTf.text, !country.isEmpty else {
            let messages = "Please select your country"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let subject = subjectTf.text, !subject.isEmpty else {
            let messages = "Please Select your subject"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let college = universityTf.text, !college.isEmpty else {
            let messages = "Please select the college"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let level = levelTf.text, !level.isEmpty else {
            let messages = "Please select the level"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        guard let centerName = centerNameTf.text, !centerName.isEmpty else {
            let messages = "Please select the center"
            self.showAlert(title: "Suggestion", message: messages)
            return
        }
        
        self.startIndicator()
        SchoolsAPIs.addTeacherApi(title: title, name: name, phone: phone, college: college, level: level, countryId: countryId, center_id: centerId, subject_id: subjectId) { (dataError, isSuccess, teachers) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if (teachers?.success)!{
                        let alert = UIAlertController(title: "Teacher", message: "Your request sent successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.showAlert(title: "Teacher", message: "Please check entered data")
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
extension AddTeacher: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelsPickerView{
            return data.levels.count
        }else if pickerView == subjectsPickerView{
            return subjects.count
        }else if pickerView == countryPickerView{
            return countries.count
        }else if pickerView == titlePickerView{
            return data.titles.count
        }else if pickerView == centerPickerView{
            return centers.count
        }else{
            return data.college.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelsPickerView{
            return data.levels[row]
        }else if pickerView == subjectsPickerView{
            return subjects[row].name
        }else if pickerView == countryPickerView{
            return countries[row].name
        }else if pickerView == titlePickerView{
            return data.titles[row]
        }else if pickerView == centerPickerView{
            return centers[row].name
        }else{
            return data.college[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelsPickerView{
            self.levelTf.text = data.levels[row]
        }else if pickerView == subjectsPickerView{
            if subjects.count != 0 {
                self.subjectTf.text = subjects[row].name
                self.subjectId = subjects[row].id ?? 0
            }
        }else if pickerView == countryPickerView{
            if countries.count != 0 {
                self.countryTf.text = countries[row].name
                self.countryId = countries[row].id ?? 0
            }
        }else if pickerView == titlePickerView{
            self.titleTf.text = data.titles[row]
        }else if pickerView == centerPickerView{
            if centers.count != 0 {
                self.centerNameTf.text = centers[row].name
                self.centerId = centers[row].id ?? 0
            }
        }else{
            self.universityTf.text = data.college[row]
        }
    }
}
