//
//  NewsApi.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class NewsApi: NSObject {

    class func newsApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ news: sliderModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.blogs, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let news = try JSONDecoder().decode(sliderModel.self, from: response.data!)
                    completion(false, true, news)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
}
