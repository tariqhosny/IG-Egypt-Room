//
//  OtherPaperPage.swift
//  IG
//
//  Created by Tariq on 3/15/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class OtherPaperPage: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var papersTableView: UITableView!
    
    var paper = [OtherPaperData]()
    var images = [String]()
    var screenName = String()
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        papersTableView.delegate = self
        papersTableView.dataSource = self
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        images = sliderHandelRefresh(bannerCollectionView: bannerCollectionView, pageControl: pageControl)
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = screenName
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func downloadAndSaveFile(_ withURLString: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        startAnimating(CGSize(width: 45, height: 45), message: "Downloading...",type: .ballPulse, color: .green, textColor: .white)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.stopAnimating()
                let activityVC = UIActivityViewController(activityItems: [tmpURL], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
        }.resume()
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
}
extension OtherPaperPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension OtherPaperPage: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paper.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherPaperCell", for: indexPath) as! OtherPaperCell
        cell.selectionStyle = .none
        cell.configureCell(name: paper[indexPath.row].fileName ?? "")
        cell.download = {
            self.downloadAndSaveFile(self.paper[indexPath.row].file ?? "") { (status) in
                print(status)
            }
        }
        
        return cell
    }
}
