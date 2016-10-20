//
//  URLViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import MapKit

class URLViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        url.delegate = self
        let coordinate = CLLocationCoordinate2D(latitude: individualInfo.locationLat!, longitude: individualInfo.locationLong!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000)
        self.mapview.setRegion(viewRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = individualInfo.location
        self.mapview.addAnnotation(annotation)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if url.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid link for others to know a little bit about you.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            individualInfo.userURL = url.text
            textField.resignFirstResponder()
            if individualInfo.haveData{
                ParseClient.sharedInstance().renewStudentLocation(completionHandlerForPut: { (info, error) in
                    if error == nil{
                        print("something")
                        let control = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                        self.present(control!, animated: true, completion: nil)
                        
                    } else{
                        print("there is an error")
                        return
                    }

                })
            }else{
                
                ParseClient.sharedInstance().postNewStudent(completionHandlerForPostStudentsData: { (info, error) in
                    
                    
                        if error == nil{
                            print("something")
                            let control = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                            self.present(control!, animated: true, completion: nil)
                            
                        } else{
                            print("there is an error")
                            return
                        }

                    
                })
            }
           
        }
        
       
        return true
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
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
