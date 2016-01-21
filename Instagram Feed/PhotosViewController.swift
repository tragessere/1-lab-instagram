//
//  ViewController.swift
//  Instagram Feed
//
//  Created by Darrell Shi on 1/21/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
  
  var instagramData: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  func loadData() {
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (dataOrNil, response, error) in
        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
              NSLog("response: \(responseDictionary)")
              
              self.instagramData = responseDictionary.valueForKey("data") as? [NSDictionary]
          }
        }
    });
    task.resume()
  }
}

