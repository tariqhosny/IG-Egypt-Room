//
//  RegisterInPrivateForAll.swift
//  IG
//
//  Created by Tariq on 2/13/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class RegisterInPrivateForAll: UIViewController {

    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var schoolTf: UITextField!
    @IBOutlet weak var subjectTf: UITextField!
    @IBOutlet weak var levelTf: UITextField!
    @IBOutlet weak var boardTf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var messageTv: UITextView!
    @IBOutlet weak var cairoSwitch: UISwitch!
    @IBOutlet weak var alexSwitch: UISwitch!
    @IBOutlet weak var regionTf: UITextField!
    @IBOutlet weak var sessionTf: UITextField!
    @IBOutlet weak var yearTf: UITextField!
    
    let levelsPickerView = UIPickerView()
    let subjectsPickerView = UIPickerView()
    let schoolPickerView = UIPickerView()//api
    let boardPickerView = UIPickerView()
    let regionPickerView = UIPickerView()
    let sessionPickerView = UIPickerView()
    let yearPickerView = UIPickerView()
    
    var schools = [SchoolsData]()
    var regions = [String]()
    let data = fixedData()
    var schoolId = Int()
    var isPrivate = Bool()
    var pageName = String()
    var pageTitle = String()
    var country = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
        boardPickerView.delegate = self
        boardPickerView.dataSource = self
        subjectsPickerView.delegate = self
        subjectsPickerView.dataSource = self
        schoolPickerView.delegate = self
        schoolPickerView.dataSource = self
        sessionPickerView.delegate = self
        sessionPickerView.dataSource = self
        regionPickerView.delegate = self
        regionPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        levelTf.inputView = levelsPickerView
        subjectTf.inputView = subjectsPickerView
        boardTf.inputView = boardPickerView
        schoolTf.inputView = schoolPickerView
        regionTf.inputView = regionPickerView
        sessionTf.inputView = sessionPickerView
        yearTf.inputView = yearPickerView
        
        cairoSwitch.setOn(true, animated: false)
        alexSwitch.setOn(false, animated: false)
        regions = data.cairoRegions
        country = "Cairo and Giza"
        
        loadSchools()
        messageTv.placeholder = "Placeholder"
        
        if isPrivate{
            pageName = "private"
        }else{
            pageName = "login"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = pageTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadSchools(){
        self.startIndicator()
        SchoolsAPIs.allSchoolsApi{ (dataError, isSuccess, schools) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let schools = schools?.data{
                        self.schools = schools
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
    
    @IBAction func cairoSwitchPressed(_ sender: UISwitch) {
        if cairoSwitch.isOn{
            alexSwitch.setOn(false, animated: true)
            regions = data.cairoRegions
            country = "Cairo and Giza"
            regionPickerView.reloadAllComponents()
        }else{
            alexSwitch.setOn(true, animated: true)
            regions = data.alexRegions
            country = "Alexandria"
            regionPickerView.reloadAllComponents()
        }
        regionTf.text = regions[0]
    }
    
    @IBAction func alexSwitchPressed(_ sender: UISwitch) {
        if alexSwitch.isOn{
            cairoSwitch.setOn(false, animated: true)
            regions = data.alexRegions
            country = "Alexandria"
            regionPickerView.reloadAllComponents()
        }else{
            cairoSwitch.setOn(true, animated: true)
            regions = data.cairoRegions
            country = "Cairo and Giza"
            regionPickerView.reloadAllComponents()
        }
        regionTf.text = regions[0]
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let name = nameTf.text, !name.isEmpty else {
            let messages = "Please enter your name"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let email = emailTf.text, !email.isEmpty else {
            let messages = "Please select your email"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard isValidEmail(testStr: email) == true else {
            let messages = "Email is invalid"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let phone = phoneTf.text, !phone.isEmpty else {
            let messages = "Please enter your phone"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let school = schoolTf.text, !school.isEmpty else {
            let messages = "Please select the school"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let region = regionTf.text, !region.isEmpty else {
            let messages = "Please Select your region"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let level = levelTf.text, !level.isEmpty else {
            let messages = "Please select the level"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let subject = subjectTf.text, !subject.isEmpty else {
            let messages = "Please Select your subject"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let college = boardTf.text, !college.isEmpty else {
            let messages = "Please select the college"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let session = sessionTf.text, !session.isEmpty else {
            let messages = "Please select the session"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let year = yearTf.text, !year.isEmpty else {
            let messages = "Please select the year"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let address = addressTf.text, !address.isEmpty else {
            let messages = "Please enter your address"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        guard let message = messageTv.text, !message.isEmpty else {
            let messages = "Please enter your message"
            self.showAlert(title: "Register", message: messages)
            return
        }
        
        self.startIndicator()
        SchoolsAPIs.loginPrivateApi(name: name, phone: phone, college: college, year: year, email: email, type: pageName, message: message, session: session, country: country, level: level, area: region, address: address, school_id: schoolId, subject: subject) { (dataError, isSuccess, register) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if (register?.success)!{
                        let alert = UIAlertController(title: "Registration", message: "Your request sent successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.showAlert(title: "Registration", message: "Please check entered data")
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
extension RegisterInPrivateForAll: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPickerView{
            return schools.count
        }else if pickerView == regionPickerView{
            return regions.count
        }else if pickerView == subjectsPickerView{
            return data.subjects.count
        }else if pickerView == levelsPickerView{
            return data.calcLevels.count
        }else if pickerView == boardPickerView{
            return data.boards.count
        }else if pickerView == sessionPickerView{
            return data.sessions.count
        }else{
            return data.years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == schoolPickerView{
            return schools[row].name
        }else if pickerView == regionPickerView{
            return regions[row]
        }else if pickerView == subjectsPickerView{
            return data.subjects[row]
        }else if pickerView == levelsPickerView{
            return data.calcLevels[row]
        }else if pickerView == boardPickerView{
            return data.boards[row]
        }else if pickerView == sessionPickerView{
            return data.sessions[row]
        }else{
            return data.years[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == schoolPickerView{
            if schools.count != 0 {
                self.schoolTf.text = schools[row].name
                self.schoolId = schools[row].id ?? 0
            }
        }else if pickerView == regionPickerView{
            if regions.count != 0 {
                self.regionTf.text = regions[row]
            }
        }else if pickerView == subjectsPickerView{
            if data.subjects.count != 0{
                self.subjectTf.text = data.subjects[row]
            }
        }else if pickerView == levelsPickerView{
            if data.calcLevels.count != 0 {
               self.levelTf.text = data.calcLevels[row]
            }
        }else if pickerView == boardPickerView{
            if data.boards.count != 0{
                self.boardTf.text = data.boards[row]
            }
        }else if pickerView == sessionPickerView{
            if data.sessions.count != 0{
                self.sessionTf.text = data.sessions[row]
            }
        }else{
            if data.years.count != 0{
                self.yearTf.text = data.years[row]
            }
        }
    }
}
