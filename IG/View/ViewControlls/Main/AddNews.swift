//
//  AddNews.swift
//  IG
//
//  Created by Tariq on 2/13/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class AddNews: UIViewController {

    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var addImagesCollectionView: UICollectionView!
    @IBOutlet weak var newsTV: UITextView!
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addImagesCollectionView.delegate = self
        addImagesCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        layout.minimumInteritemSpacing = (addImagesCollectionView.frame.size.width - 320)/3
        layout.minimumLineSpacing = 1
        addImagesCollectionView.collectionViewLayout = layout
        navigationController?.navigationBar.topItem?.title = "Add News"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }

}
extension AddNews: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addNewsImageCell", for: indexPath) as! addNewsImageCell
        
        cell.addImage = {
            let piker = UIImagePickerController()
            piker.allowsEditing = true
            piker.sourceType = .photoLibrary
            piker.delegate = self
            let title = "Photo Source"
            let message = "Chose A Source"
            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let titles = "Camera"
            actionSheet.addAction(UIAlertAction(title: titles, style: .default, handler: { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    piker.sourceType = .camera
                    self.present(piker, animated: true, completion: nil)
                }else {
                    print("notFound")
                }
            }))
            let titless = "Photo Library"
            actionSheet.addAction(UIAlertAction(title: titless, style: .default, handler: { (action:UIAlertAction) in
                piker.sourceType = .photoLibrary
                self.present(piker, animated: true, completion: nil)
            }))
            let titlesss = "Cancel"
            actionSheet.addAction(UIAlertAction(title: titlesss, style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 80)
    }
}
