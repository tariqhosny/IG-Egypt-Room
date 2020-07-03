//
//  TeacherFinderModel.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct TeacherFinderModel: Codable{
    var success: Bool?
    var data: [TeacherFinderData]?
    var message: String?
}

struct TeacherFinderData: Codable{
    var id: Int?
    var colleges: [String]?
    var levels: [String]?
    var teacherData: TeacherDataModel?
    var subjectAndCenter: [SubjectAndCenterModel]?
}

struct TeacherDataModel: Codable{
    var id: Int?
    var title: String?
    var name: String?
    var phone: String?
    var email: String?
}

struct SubjectAndCenterModel: Codable{
    var subject: String?
    var center: SubjectCentersModel?
}

struct SubjectCentersModel: Codable{
    var id: Int?
    var name: String?
    var phone: String?
    var email: String?
    var address: String?
}
