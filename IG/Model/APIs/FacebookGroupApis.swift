//
//  FacebookGroupApis.swift
//  IG
//
//  Created by Tariq on 3/1/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class FacebookGroupApis: NSObject {
    
    class func suggestionApi(name: String, email: String, url: String, messageTitle: String, message: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ suggestion: FacebookModel?)-> Void){
        let parametars = [
            "name": name,
            "email": email,
            "message": message,
            "title_message": messageTitle,
            "url": url
        ]
        Alamofire.request(URLs.suggestions, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let suggestion = try JSONDecoder().decode(FacebookModel.self, from: response.data!)
                    completion(false, true, suggestion)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func banApi(name: String, email: String, url: String, reason: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ ban: FacebookModel?)-> Void){
        let parametars = [
            "name": name,
            "email": email,
            "reasone": reason,
            "url": url
        ]
        Alamofire.request(URLs.bans, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let ban = try JSONDecoder().decode(FacebookModel.self, from: response.data!)
                    completion(false, true, ban)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
}
