//
//  addNewsImageCell.swift
//  IG
//
//  Created by Tariq on 2/16/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class addNewsImageCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageBtn: UIButton!
    
    var addImage: (()->())?
    
    var picker_imag: UIImage? {
        didSet{
            guard let image = picker_imag else {return}
            self.imageBtn.setImage(image, for: .normal)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            //                cell.imageBtn.setImage(editedImage, for: .normal)
            self.imageBtn.imageView?.image = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //                cell.imageBtn.setImage(originalImage, for: .normal)
            self.imageBtn.imageView?.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageBtnPressed(_ sender: UIButton) {
        addImage?()
    }
}
