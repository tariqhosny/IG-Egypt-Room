//
//  fixedData.swift
//  IG
//
//  Created by Tariq on 2/24/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct fixedData{
    let college = ["Cambridge", "Edexcel", "Oxford"]
    let levels = ["O", "A"]
    let sessions = ["S", "W", "M", "J"]
    let titles = ["Dr", "Eng", "Ms", "Miss", "Mrs"]
    var years: [String]{
        get{
            var year = [String]()
            for i in 0...50{
                year.insert(String(2000 + i), at: i)
            }
            return year
        }
        
    }
    
    //Grades Calulator Module
    let calcLevels = ["O", "A", "AS"]
    func calcGrades(level: String) -> (grades: [String], values: [Int]){
        if level == calcLevels[0]{
            let grades = ["A*", "A", "B", "C", "9", "8", "7", "6", "5", "4"]
            let gradesValues = [100, 95, 85, 70, 100, 100, 95, 88, 82, 70]
            return (grades, gradesValues)
        }else if level == calcLevels[1]{
            let grades = ["A*", "A", "B", "C", "D", "9", "8", "7", "6", "5", "4"]
            let gradesValues = [100, 95, 85, 70, 60, 100, 100, 95, 88, 82, 70]
            return (grades, gradesValues)
        }else{
            let grades = ["A", "B", "C", "D", "9", "8", "7", "6", "5", "4"]
            let gradesValues = [95, 85, 70, 60, 100, 100, 95, 88, 82, 70]
            return (grades, gradesValues)
        }
    }
    
    //Register Data Module
    let boards = ["Combridge", "Edixcel", "Both"]
    
    let subjects = ["Arabic", "Accounting", "Art and Design", "Biology", "Business", "Chemistry", "Computer Science", "Deutch", "Economics", "English as a Second Language", "French", "Human Biology", "ICT", "Math", "Physics", "Travel and Tourism"]
    
    let cairoRegions = ["6th of October", "Abbassia", "Agouza", "Dokki", "El Marg", "El Matareya, Cairo", "El Shorouk", "Fifth Settlement", "Heliopolis, Cairo", "Helwan", "Imbaba", "Kerdasa", "Maadi", "Madinaty", "Manshiyat Naser", "Mohandessin", "Mokattam", "Nasr City", "New Cairo", "Obour", "Rehab", "Sheikh Zayed City", "Shubra El Kheima", "Zamalek"]
    
    let alexRegions = ["Amreya", "Anfoushi", "Asafra", "Azarita", "Bahary", "Bakos", "Baucalis", "Bolkly", "Camp Chezar", "Cleopatra", "Dekhela", "Dekhela", "Downtown", "El Atareen", "El Gomrok", "El Ibrahimiy", "El Labban", "El Maamora Beach", "El Maamora", "El Mandara", "El Mansheya", "El Max", "El Qabary", "El Saraya", "El Soyof", "Fleming", "Gianaclis", "Glim", "Hadara", "Kafr Abdu", "Karmoz", "Kom El Deka", "Louran", "Mahatet El Raml", "Miami", "Moharam Bek", "Montaza", "Roshdy", "Saba Pasha", "Safar", "San Stefano", "Shatby", "Shods", "Sidi Bishr", "Sidi Gaber", "Smouha", "Sporting", "Stanley", "Tharwat", "Victoria", "Wardeyan", "Zezenia"]
}
