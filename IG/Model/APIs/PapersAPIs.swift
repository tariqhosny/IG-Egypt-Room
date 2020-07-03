//
//  PapersAPIs.swift
//  IG
//
//  Created by Tariq on 3/15/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import Alamofire

class PapersAPIs: NSObject {
    
    class func pastPaperApi(college: String, level: String, year: String, session: String, subjectCode: String, paperType: String, variantName: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ paper: paperModel?)-> Void){
        let parametars = [
            "college": college,
            "level": level,
            "year": year,
            "session": session,
            "subjectCode": subjectCode,
            "paperType": paperType,
            "variantName": variantName
        ]
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.past_papers, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let paper = try JSONDecoder().decode(paperModel.self, from: response.data!)
                    completion(false, true, paper)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }

    class func otherPaperApi(college: String, level: String, year: String, session: String, subjectCode: String, paperType: String, variantName: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ paper: OtherPaperModel?)-> Void){
        let parametars = [
            "college": college,
            "level": level,
            "year": year,
            "session": session,
            "subjectCode": subjectCode,
            "paperType": paperType,
            "variantName": variantName
        ]
        let header = [
            "X-localization": "en"
        ]
        Alamofire.request(URLs.other_papers, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let paper = try JSONDecoder().decode(OtherPaperModel.self, from: response.data!)
                    completion(false, true, paper)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func subjectsApi(college: String, level: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ subject: SubjectsModel?)-> Void){
        let parametars = [
            "college": college,
            "level": level
        ]
        Alamofire.request(URLs.getSubjects, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let subject = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, subject)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func allSubjectsApi(completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ subject: SubjectsModel?)-> Void){
        Alamofire.request(URLs.allSubjects, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let subject = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, subject)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
    
    class func allSubjectsByLevelApi(level: String, completion: @escaping(_ dataError: Bool?, _ success: Bool?, _ subject: SubjectsModel?)-> Void){
        let parameter = ["level": level]
        Alamofire.request(URLs.allSubjectsByLevel, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            do{
                switch response.result
                {
                case .failure(let error):
                    print(error)
                    completion(false, false, nil)
                case .success(let value):
                    print(value)
                    let subject = try JSONDecoder().decode(SubjectsModel.self, from: response.data!)
                    completion(false, true, subject)
                }
            }catch{
                completion(true, false, nil)
            }
        }
    }
}
