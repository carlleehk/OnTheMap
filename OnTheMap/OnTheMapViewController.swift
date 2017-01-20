//
//  OnTheMapViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/29/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit
import MapKit

class OnTheMapViewController: UIViewController,  MKMapViewDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        func locationData() -> [[String: Any]]{
            var info: [String:Any]  = [:]
            var infos = [info]
            let data = selectUserInfo.selectuserInfo
            for datas in data{
                info["firstName"] = datas.firstName
                info["lastName"] = datas.lastName
                info["latitude"] = datas.latitude
                info["longitude"] = datas.longitude
                info["mapString"] = datas.mapString
                info["mediaURL"] = datas.mediaURL
                info["objectId"] = datas.objectId
                infos.append(info)
            }
            infos.remove(at: 0)
            print("thee inf: \(infos)")
            return infos
        }
        
        ParseClient.sharedInstance().getIndividualData { (data, error) in
            if error == nil && data?.count != 0{
                
                let locations = locationData()
                selectUserInfo.userInfoDictionary.append(locations[0])
                print("the location is \(selectUserInfo.userInfoDictionary)")
                print("the data is: \(data?.count)")
                var annotations = [MKPointAnnotation]()
                for dictionary in locations {
                    print("The info is \(dictionary)")
                    individualInfo.objectID = dictionary["objectId"] as! String
                    print("....?: \(individualInfo.objectID)")
                    
                    guard let lat = dictionary["latitude"] as? Double, let long = dictionary["longitude"] as? Double else{
                        print("No Location Data")
                        self.viewDidLoad()
                        return
                    }
                    //let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    //let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let mediaURL = dictionary["mediaURL"] as! String
                    let annotation = MKPointAnnotation()
                    let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5000000, 5000000)
                    self.map.setRegion(viewRegion, animated: true)
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
                
                self.map.addAnnotations(annotations)
                
                
                
            } else if (error != nil){
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                let control = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                self.present(control, animated: true, completion: nil)
            }
            
         
        }
        


        ParseClient.sharedInstance().getStudentsData { (data, error) in
                if error == nil{
                    
                    let locations = locationData()
                    selectUserInfo.userInfoDictionary = locations
                    print("the data is: \(locations)")
                    var annotations = [MKPointAnnotation]()
                    for dictionary in locations {
                        guard let lat = dictionary["latitude"] as? Double, let long = dictionary["longitude"] as? Double else{
                            
                            print("No Location Data")
                            self.viewDidLoad()
                            return
                        }
                        //let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                        //let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let first = dictionary["firstName"] as! String
                        let last = dictionary["lastName"] as! String
                        let mediaURL = dictionary["mediaURL"] as! String
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        annotations.append(annotation)
                    }
                    
                    self.map.addAnnotations(annotations)
                    
                    
                    
                } else{
                   let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
                }
    
    @IBAction func logout(_ sender: AnyObject) {
        
        UdacityClient.sharedInstance().deleteSession { (success, errorString) in
            if success{
                print("Sucessfully delete Session")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else{
                print(errorString)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)! as URL)
            }
        }
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.viewDidLoad()
    }
  
    @IBAction func findLocation(_ sender: AnyObject) {
        
        individualInfo.haveData = true
        let alertController = UIAlertController(title: "Attention", message: "There is already a user location data, do you want to overwrite it?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            individualInfo.haveData = true
            let control = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            self.present(control, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
