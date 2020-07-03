//
//  CenterFilter.swift
//  IG
//
//  Created by Tariq on 3/17/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class CenterFilter: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var countryTf: UITextField!
    @IBOutlet weak var areaTf: UITextField!
    
    var images = [String]()
    var area = [SubjectsData]()
    var countries = [SubjectsData]()
    var countryId = Int()
    var areaId = Int()
    var counter = 1
    
    let countryPickerView = UIPickerView()
    let areaPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        areaPickerView.delegate = self
        areaPickerView.dataSource = self
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        countryTf.inputView = countryPickerView
        areaTf.inputView = areaPickerView
        
        loadCountries()
        
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Center Finder"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func loadCountries(){
        self.startIndicator()
        CountriesAPIs.countriesApi{ (dataError, isSuccess, countries) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let countries = countries?.data{
                        self.countries = countries
                        self.countryPickerView.reloadAllComponents()
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
    func loadAreas(id: Int){
        self.startIndicator()
        CountriesAPIs.areasApi(countryId: id){ (dataError, isSuccess, area) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let area = area?.data{
                        self.area = area
                        self.areaPickerView.reloadAllComponents()
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        if counter < images.count {
            let index = IndexPath.init(item: counter, section: 0)
            pageControl.currentPage = counter
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        }else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            pageControl.currentPage = counter
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter = 1
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.startIndicator()
        SchoolsAPIs.centersApi(areaId: areaId, countryId: countryId) { (dataError, isSuccess, center) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if let center = center?.data{
                        if center.count == 0{
                            self.showAlert(title: "Center", message: "No Centers Found")
                        }else{
                            let vc = UIStoryboard.init(name: "IGGuide", bundle: Bundle.main).instantiateViewController(withIdentifier: "CenterFinder") as? CenterFinder
                            vc?.centers = center
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    }
                    self.stopAnimating()
                }else{
                    self.showAlert(title: "Connection", message: "Please check your internet connection")
                    self.stopAnimating()
                }
            }
        }
    }
    
}
extension CenterFilter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configureCell(images: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension CenterFilter: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView{
            return countries.count
        }else{
            return area.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView{
            return countries[row].name
        }else{
            return area[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView{
            if countries.count != 0 {
                self.countryTf.text = countries[row].name
                self.countryId = countries[row].id ?? 0
                self.loadAreas(id: self.countryId)
            }
        }else{
            if area.count != 0 {
                self.areaTf.text = area[row].name
                self.areaId = area[row].id ?? 0
            }
        }                                
    }
    
}
