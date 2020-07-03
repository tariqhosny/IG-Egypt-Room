//
//  TimetableModel.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct TimetableModel: Codable{
    var success: Bool?
    var data: TimetableUniversities?
    var message: String?
}

struct TimetableUniversities: Codable{
    var cambridge: [UniversitiesData]?
    var edexcel: [UniversitiesData]?
    var oxford: [UniversitiesData]?
}

struct UniversitiesData: Codable{
    var id: Int?
    var college: String?
    var name: String?
    var file: String?
}
