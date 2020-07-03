//
//  sliderResponse.swift
//  IG
//
//  Created by Tariq on 2/26/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import Foundation

class sliderResponse {
    class func getSlider() -> [String]?{
        let defUser = UserDefaults.standard
        return (defUser.object(forKey: "slider") as? [String])
    }
    
    class func saveSlider(slider: [sliderData]){
        let defUser = UserDefaults.standard
        var images = [String]()
        for n in 0...slider.count-1{
            images.append(slider[n].image ?? "")
        }
        defUser.setValue(images, forKey: "slider")
        defUser.synchronize()
    }
}
