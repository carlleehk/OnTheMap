//
//  DataTableViewController.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/20/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import UIKit

class DataTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(selectUserInfo.userInfoDictionary.count)
        return selectUserInfo.userInfoDictionary.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapInfo")!
        let detail = selectUserInfo.userInfoDictionary[indexPath.row]
        cell.textLabel?.text = "\(detail["firstName"]!) \(detail["lastName"]!)"
        cell.detailTextLabel?.text = "\(detail["mediaURL"]!)"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = selectUserInfo.userInfoDictionary[indexPath.row]
        let urlString = NSURL(string: detail["mediaURL"] as! String)
        guard let url = urlString as? URL else{
            let alertController = UIAlertController(title: "Error", message: "The URL is invalid", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return

        }

        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        
    }
    
    
    @IBAction func logout(_ sender: AnyObject) {
        
        UdacityClient.sharedInstance().deleteSession { (success, errorString) in
            if success{
                print("Sucessfully delete Session")
                self.dismiss(animated: true, completion: nil)
            } else{
                print(errorString)
            }
        }

    }
    
    
    @IBAction func getLocation(_ sender: AnyObject) {
        
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
