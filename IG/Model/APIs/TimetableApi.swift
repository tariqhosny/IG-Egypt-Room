//
//  TimetableApi.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class TimetableApi: NSObject {

    class func timetableApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ tables: TimetableModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.timetables, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let tables = try JSONDecoder().decode(TimetableModel.self, from: response.data!)
                    completion(false, true, tables)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
}
