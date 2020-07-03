//
//  SchoolsAPIs.swift
//  IG
//
//  Created by Tariq on 3/17/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class SchoolsAPIs: NSObject {
    
    class func schoolsApi(name: String, countryId: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ school: SchoolsModel?)-> Void){
        
        let parametars = [
            "state_id": countryId,
            "search": name
        ] as [String : Any]
        print(parametars)
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.schools, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let school = try JSONDecoder().decode(SchoolsModel.self, from: response.data!)
                    completion(false, true, school)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func allSchoolsApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ school: SchoolsModel?)-> Void){
        
        Alamofire.request(URLs.allSchools, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let school = try JSONDecoder().decode(SchoolsModel.self, from: response.data!)
                    completion(false, true, school)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func centersApi(areaId: Int, countryId: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ center: CenterModel?)-> Void){
        
        let parametars = [
            "state_id": areaId,
            "city_id": countryId
        ] as [String : Any]
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.center, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let center = try JSONDecoder().decode(CenterModel.self, from: response.data!)
                    completion(false, true, center)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func allCentersApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ center: CenterModel?)-> Void){
        
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.center, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let center = try JSONDecoder().decode(CenterModel.self, from: response.data!)
                    completion(false, true, center)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func centersByCountryApi(countryId: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ center: CenterModel?)-> Void){
        
        let parametars = [
            "city_id": countryId
        ] as [String : Any]
        Alamofire.request(URLs.getCenters, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let center = try JSONDecoder().decode(CenterModel.self, from: response.data!)
                    completion(false, true, center)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func teachersApi(subjectId: Int, centerId: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ teacher: TeacherFinderModel?)-> Void){
        
        let parametars = [
            "subject_id": subjectId,
            "center_id": centerId
        ] as [String : Any]
        Alamofire.request(URLs.teacher_finder, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let teacher = try JSONDecoder().decode(TeacherFinderModel.self, from: response.data!)
                    completion(false, true, teacher)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func addTeacherApi(title: String, name: String, phone: String, college: String, level: String, countryId: Int, center_id: Int, subject_id: Int, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ isAdded: FacebookModel?)-> Void){
        let parametars = [
            "title": title,
            "name": name,
            "phone": phone,
            "college": college,
            "level": level,
            "center_id": center_id,
            "subject_id": subject_id,
            "city_id": countryId
            ] as [String : Any]
        Alamofire.request(URLs.addTeacher, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
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
    
    class func loginPrivateApi(name: String, phone: String, college: String, year: String, email: String, type: String, message: String, session: String, country: String, level: String, area: String, address: String, school_id: Int, subject: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ isAdded: FacebookModel?)-> Void){
        let parametars = [
            "name": name,
            "phone": phone,
            "board": college,
            "level": level,
            "year": year,
            "area": area,
            "email": email,
            "subject": subject,
            "school_id": school_id,
            "country": country,
            "session": session,
            "message": message,
            "type": type,
            "address": address
            ] as [String : Any]
        Alamofire.request(URLs.loginPrivate, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
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
    
}
