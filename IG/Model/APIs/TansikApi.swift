//
//  TansikApi.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class TansikApi: NSObject {

    class func tansikApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ tansik: TansikModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.tansiks, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let tansik = try JSONDecoder().decode(TansikModel.self, from: response.data!)
                    completion(false, true, tansik)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
}
