//
//  CenterModel.swift
//  IG
//
//  Created by Tariq on 3/18/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct CenterModel: Codable{
    var success: Bool?
    var data: [CenterData]?
    var message: String?
}

struct CenterData: Codable{
    var id: Int?
    var email: String?
    var phone: String?
    var college: String?
    var lat: String?
    var lng: String?
    var city: String?
    var state: String?
    var name: String?
    var description: String?
    var address: String?
    var images: [ImagesModel]?
    var teachers: [TeachersModel]?
}

struct ImagesModel: Codable{
    var id: Int?
    var image: String?
}

struct TeachersModel: Codable{
    var name: String?
    var subjects: [String]?
    var levels: [String]?
}
