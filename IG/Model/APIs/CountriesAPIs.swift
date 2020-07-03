//
//  CountriesAPIs.swift
//  IG
//
//  Created by Tariq on 3/17/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class CountriesAPIs: NSObject {

    class func countriesApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ country: SubjectsModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.country, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let country = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, country)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func areasApi(countryId: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ area: SubjectsModel?)-> Void){
        
        let parametars = [
            "city_id": countryId
        ]
        
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.area, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let area = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, area)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func allAreasApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ area: SubjectsModel?)-> Void){
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.allArea, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let area = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, area)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
}
