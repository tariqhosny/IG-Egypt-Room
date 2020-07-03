//
//  StaticPagesApi.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class StaticPagesApi: NSObject {

    class func staticPagesApi(staticPages: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ tables: staticPagesModel?)-> Void){
        let parameters = [
            "pageName": staticPages
        ]
        Alamofire.request(URLs.staticPages, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let data = try JSONDecoder().decode(staticPagesModel.self, from: response.data!)
                    completion(false, true, data)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func contactUsApi(email: String, name: String, phone: String, message: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ contact: FacebookModel?)-> Void){
        let parametars = [
            "name": name,
            "email": email,
            "phone": phone,
            "message": message
            ]
        Alamofire.request(URLs.contact, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let contact = try JSONDecoder().decode(FacebookModel.self, from: response.data!)
                    completion(false, true, contact)
                }
            }catch{
                completion(false, true, nil)
            }
        }
    }
    
}
