//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        location.delegate = self

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if location.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Location. It may be in the form of City, State", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else{
        
            individualInfo.location = location.text!
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location.text!) { (placemarks, error) in
                
                if let placemarks = placemarks {
                    if placemarks.count > 0{
                    let placemark = placemarks[0] as CLPlacemark
                    let location = placemark.location?.coordinate
                    individualInfo.locationLat = location?.latitude
                    individualInfo.locationLong = location?.longitude
                }
                }else {
                    let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Location. It may be in the form of City, State", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
        }
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func getLocation(_ sender: AnyObject) {
        let control = storyboard?.instantiateViewController(withIdentifier: "URLViewController") as! URLViewController
        present(control, animated: true, completion: nil)
    }
    
}

