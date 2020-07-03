//
//  calculatorCell.swift
//  IG
//
//  Created by Tariq on 2/16/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class calculatorCell: UITableViewCell {

    @IBOutlet weak var levelTf: UITextField!
    @IBOutlet weak var subjectTf: UITextField!
    @IBOutlet weak var gradeTf: UITextField!
    @IBOutlet weak var deleteCellBtn: UIButton!
    
    let vc = UIViewController()
    
    var deleteCell: (()->())?
    var data = fixedData()
    var subjects = [SubjectsData]()
    let levelsPickerView = UIPickerView()
    let subjectsPickerView = UIPickerView()
    let gradsPickerView = UIPickerView()
    var selectedGrade = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
        subjectsPickerView.delegate = self
        subjectsPickerView.dataSource = self
        gradsPickerView.delegate = self
        gradsPickerView.dataSource = self
        
        levelTf.inputView = levelsPickerView
        subjectTf.inputView = subjectsPickerView
        gradeTf.inputView = gradsPickerView
        levelTf.text = data.calcLevels[0]
        loadSubjects(level: data.calcLevels[0])
        gradeTf.text = data.calcGrades(level: data.calcLevels[0]).grades[0]
        selectedGrade = data.calcGrades(level: data.calcLevels[0]).values[0]
    }

    func getGradeValue() -> Int{
        return selectedGrade
    }
    
    func loadSubjects(level: String){
        vc.startIndicator()
        PapersAPIs.allSubjectsByLevelApi(level: level){ (dataError, isSuccess, subject) in
            if dataError!{
                print("data error")
                self.vc.stopAnimating()
            }else{
                if isSuccess!{
                    if let subject = subject?.data{
                        self.subjects = subject
                        if self.subjects.count != 0{
                            self.subjectTf.text = self.subjects[0].name
                        }else{
                            self.subjectTf.text = ""
                        }
                        self.subjectsPickerView.reloadAllComponents()
                    }
                    self.vc.stopAnimating()
                }else{
                    self.vc.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.vc.stopAnimating()
                }
            }
        }
    }
    
    func isSubjectFill() -> Bool{
        if subjectTf.text == ""{
            return false
        }else{
            return true
        }
    }
    
    @IBAction func addCellPressed(_ sender: Any) {
        deleteCell?()
    }
}

extension calculatorCell: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelsPickerView{
            return data.calcLevels.count
        }else if pickerView == subjectsPickerView{
            return subjects.count
        }else{
            return data.calcGrades(level: levelTf.text ?? "").grades.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelsPickerView{
            return data.calcLevels[row]
        }else if pickerView == subjectsPickerView{
            return subjects[row].name
        }else{
            return data.calcGrades(level: levelTf.text ?? "").grades[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelsPickerView{
            self.levelTf.text = data.calcLevels[row]
            self.loadSubjects(level: data.calcLevels[row])
            gradeTf.text = data.calcGrades(level: data.calcLevels[row]).grades[0]
            selectedGrade = data.calcGrades(level: data.calcLevels[row]).values[0]
        }else if pickerView == subjectsPickerView{
            if subjects.count != 0{
                self.subjectTf.text = subjects[row].name
            }
        }else{
            self.gradeTf.text = data.calcGrades(level: levelTf.text ?? "").grades[row]
            selectedGrade = data.calcGrades(level: levelTf.text ?? "").values[row]
        }
    }
}
