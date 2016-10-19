//
//  URLViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import MapKit

class URLViewController: UIViewController {

    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(individualInfo.location)
        print(individualInfo.locationLong)

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
