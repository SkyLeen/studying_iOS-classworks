//
//  LoginFromController.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let login = "skyleen"
    let password = "123456"
    let credentials = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginField.text = credentials.string(forKey: "userName")
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
        showCredentials()
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
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        showCredentials()
        removeDataBase()
    }

    func logIn() -> Bool {
        guard loginField.text == login && passwordField.text == password else {
            present(AlertHelper().showAlert(withTitle: "Warning", message: "Login or password incorrect"), animated: true)
            return false
        }
        saveCredentials()
        removeCredentials()
        return true
    }
    
    private func showCredentials() {
        loginField.text = credentials.string(forKey: "userName")
    }
    
    private func saveCredentials() {
         credentials.set(loginField.text, forKey: "userName")
    }
    
    private func removeCredentials() {
        loginField.text?.removeAll()
        passwordField.text?.removeAll()
    }
    
    private func removeDataBase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
