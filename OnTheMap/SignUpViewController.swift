//
//  SignUpViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/17/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        let request = NSURLRequest(url: url! as URL)
        webView.loadRequest(request as URLRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
