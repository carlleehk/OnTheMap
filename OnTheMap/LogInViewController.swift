//
//  ViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/28/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    


    @IBAction func login(_ sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateViewController(username: username.text!, password: password.text!, hostViewController: self) { (success, error) in
            
            performUIUpdateOnMain {
                
                if success{
                    
                    self.completeLogin()
                } else{
                    
                    let alertController = UIAlertController(title: "Invalid Login", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func completeLogin(){
        performUIUpdateOnMain {
            if userData.userStat{
                let control = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.present(control, animated: true, completion: nil)
            } else{
                let alertController = UIAlertController(title: "Invalid Login", message: "Enter your username or password again. Or click to regesiter if you don't have an account", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }

    }
    
    @IBAction func signUp(_ sender: AnyObject) {

        let control = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        present(control!, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y = getKeyboardHeight(notification: notification) * -1
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    /*func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }*/

}

