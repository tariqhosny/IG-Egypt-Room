//
//  sliderModel.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct sliderModel: Codable{
    var success: Bool?
    var data: [sliderData]?
    var message: String?
}

struct sliderData: Codable{
    var id: Int?
    var image: String?
    var title: String?
    var description: String?
    var created_at: String?
}
