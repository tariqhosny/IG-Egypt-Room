//
//  StudyAbroadModel.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct staticPagesModel: Codable{
    var success: Bool?
    var data: staticPagesData?
    var message: String?
}

struct staticPagesData: Codable{
    var id: Int?
    var title: String?
    var pageName: String?
    var image: String?
    var description: String?
    var created_at: String?
}
