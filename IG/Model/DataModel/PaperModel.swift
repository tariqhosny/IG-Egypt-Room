//
//  PaperModel.swift
//  IG
//
//  Created by Tariq on 3/15/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct paperModel: Codable{
    var success: Bool?
    var data: [paperList]?
    var message: String?
}

struct paperList: Codable{
    var paper: String?
    var files: [OtherPaperData]?
}

struct OtherPaperModel: Codable{
    var success: Bool?
    var data: [OtherPaperData]?
    var message: String?
}

struct OtherPaperData: Codable{
    var id: Int?
    var subjectCode: String?
    var session: String?
    var year: String?
    var paperType: String?
    var paperNumber: String?
    var variantName: String?
    var fileName: String?
    var file: String?
    var college: String?
    var level: String?
}

