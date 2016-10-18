//
//  ViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/28/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var sessionID: String = ""
    var fN: String!
    var accountKey: String = ""
    /*need to change to fasle later*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(_ sender: AnyObject) {
        UdacityClient.sharedInstance().authenticateViewController(username: username.text!, password: password.text!, hostViewController: self) { (success, errorString) in
            performUIUpdateOnMain {
                if success{
                    self.completeLogin()
                } else{
                    let alertController = UIAlertController(title: "Invalid Login", message: "Enter your username or password again. Or click to regesiter if you don't have an account", preferredStyle: .alert)
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
       
        
    

}

