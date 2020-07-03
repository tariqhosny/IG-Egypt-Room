//
//  SchoolsModel.swift
//  IG
//
//  Created by Tariq on 3/17/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct SchoolsModel: Codable{
    var success: Bool?
    var data: [SchoolsData]?
    var message: String?
}

struct SchoolsData: Codable{
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
}
