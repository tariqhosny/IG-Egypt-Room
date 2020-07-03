//
//  SubjectsModel.swift
//  IG
//
//  Created by Tariq on 3/15/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct SubjectsModel: Codable{
    var success: Bool?
    var data: [SubjectsData]?
    var message: String?
}

struct SubjectsData: Codable{
    var id: Int?
    var code: String?
    var name: String?
    var level: String?
}
