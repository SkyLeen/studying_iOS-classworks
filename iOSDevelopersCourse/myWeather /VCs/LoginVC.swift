//
//  LoginFromController.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    
    let login = "skyleen"
    let password = "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKbGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        scrollView?.addGestureRecognizer(hideKbGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = logIn()
        return result
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let kbInfo = notification.userInfo! as NSDictionary
        let kbSize = (kbInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0)
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    func logIn() -> Bool {
        guard loginField.text == login && passwordField.text == password else {
            showAlert()
            return false
        }
        removeCredentials()
        return true
    }
    
    func removeCredentials() {
        loginField.text?.removeAll()
        passwordField.text?.removeAll()
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Warning", message: "Login or password incorrect", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(actionButton)
        present(alertController, animated: true)
    }
}
