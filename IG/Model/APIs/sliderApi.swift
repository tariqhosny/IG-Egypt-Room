//
//  sliderApi.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class sliderApi: NSObject {

    class func sliderApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ photos: sliderModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.sliders, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let images = try JSONDecoder().decode(sliderModel.self, from: response.data!)
                    completion(false, true, images)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
}
