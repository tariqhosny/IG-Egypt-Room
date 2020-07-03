//
//  FacebookGroupModel.swift
//  IG
//
//  Created by Tariq on 3/1/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct FacebookModel: Codable{
    var success: Bool?
    var message: String?
}

struct PolicyModel: Codable{
    var success: Bool?
    var data: PolicyData?
    var message: String?
}

struct PolicyData: Codable{
    var id: Int?
    var title: String?
    var description: String?
}
