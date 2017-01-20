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
    
    var messageFrame = UIView()
    var strLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var findOnTheMap: UIButton!
    @IBOutlet weak var location: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        location.delegate = self
        findOnTheMap.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(LocationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LocationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func progressBarDisplay(msg: String, indicator: Bool){
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if location.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Location. It may be in the form of City, State", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else{
        
            individualInfo.location = location.text!
            let geocoder = CLGeocoder()
            self.progressBarDisplay(msg: "Finding Location", indicator: true)
            geocoder.geocodeAddressString(location.text!) { (placemarks, error) in
                
                self.messageFrame.removeFromSuperview()
                if let error = error{
                    print(error)
                    self.messageFrame.removeFromSuperview()
                    let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Location. It may be in the form of City, State", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else{
                
                if let placemarks = placemarks {
                    self.messageFrame.removeFromSuperview()
                    if placemarks.count > 0{
                    let placemark = placemarks[0] as CLPlacemark
                    let location = placemark.location?.coordinate
                    individualInfo.locationLat = location?.latitude
                    individualInfo.locationLong = location?.longitude
                    self.findOnTheMap.isEnabled = true
                }
                }else {
                    self.messageFrame.removeFromSuperview()
                    let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Location. It may be in the form of City, State", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
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
    
       
    func keyboardWillShow(notification: NSNotification) {
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
    }

    
}

