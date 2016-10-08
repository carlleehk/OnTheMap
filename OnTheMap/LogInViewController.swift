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
    var reg: Bool  = true
    
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
                } else {
                    print("error")
                }
            }
        }
    }
    
    private func completeLogin(){
        performUIUpdateOnMain {
            if self.reg{
                let control = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.present(control, animated: true, completion: nil)
            }
            
        }

    }
    
       
        
    

}

