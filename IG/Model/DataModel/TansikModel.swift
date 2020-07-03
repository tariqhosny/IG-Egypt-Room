//
//  TansikModel.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

struct TansikModel: Codable{
    var success: Bool?
    var data: TansikTypes?
    var message: String?
}

struct TansikTypes: Codable{
    var old: [TansikData]?
    var notice: [TansikData]?
    var rules: [TansikData]?
}

struct TansikData: Codable{
    var id: Int?
    var image: String?
    var name: String?
    var description: String?
    var created_at: String?
}
