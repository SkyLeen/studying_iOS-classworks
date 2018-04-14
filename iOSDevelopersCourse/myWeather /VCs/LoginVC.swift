//
//  LoginFromController.swift
//  iOSDevelopersCourse
//
//  Created by Natalya on 17/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
  
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
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        checkCredentials { [weak self] checkResult in
            if checkResult {
                self?.performSegue(withIdentifier: "goNextView", sender: nil)
                self?.saveCredentials()
                self?.removeCredentials()
            }
        }
    }
    
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        showCredentials()
        removeDataBase()
    }
    
    private func checkCredentials(completion: @escaping (Bool) -> ()) {
        let login = loginField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: login, password: password) { (user, error) in
            completion(user != nil)
        }
    }
    
    private func showCredentials() {
        loginField.text = credentials.string(forKey: "userName")
    }
    
    private func saveCredentials() {
         credentials.set(loginField.text, forKey: "userName")
    }
    
    private func removeCredentials() {
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
