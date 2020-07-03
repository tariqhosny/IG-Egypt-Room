//
//  ContactUs.swift
//  Chic Chicken
//
//  Created by Tariq on 3/2/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit

class ContactUs: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTf.delegate = self
        phoneTf.delegate = self
        message.placeholder = "Message"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Contact Us"
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTf{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z أ إ  ض ص ث ق ف غ ع ه خ ح  ج د ش ي ب ل ا ت ن م ك  ط ئ ء ؤ ر س ذ لا ى ة و ز ظ].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            return true
        }else{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^0-9٠-٩+#*].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            return true
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let name = nameTf.text, !name.isEmpty else {
            let messages = "Please enter your name"
            self.showAlert(title: "Contact Us", message: messages)
            return
        }
        guard let email = emailTf.text, !email.isEmpty else {
            let messages = "Please enter your email"
            self.showAlert(title: "Contact Us", message: messages)
            return
        }
        guard isValidEmail(testStr: emailTf.text ?? "") == true else {
            let messages = "Email is invalid"
            self.showAlert(title: "Contact Us", message: messages)
            return
        }
        guard let phone = phoneTf.text, !phone.isEmpty else {
            let messages = "Please enter your Phone Number"
            self.showAlert(title: "Contact Us", message: messages)
            return
        }
        guard let message = message.text, !message.isEmpty else {
            let messages = "Please enter your message"
            self.showAlert(title: "Contact Us", message: messages)
            return
        }
        self.startIndicator()
        StaticPagesApi.contactUsApi(email: email, name: name, phone: phone, message: message) { (dataError, isSuccess, contact) in
            if dataError!{
                print("data error")
                self.stopAnimating()
            }else{
                if isSuccess!{
                    if (contact?.success)!{
                        let alert = UIAlertController(title: "Contact Us", message: "Your Message sent successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.showAlert(title: "Registration", message: "Please check entered data")
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
