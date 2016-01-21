//
//  ViewController.swift
//  Instagram Feed
//
//  Created by Darrell Shi on 1/21/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var instagramTableView: UITableView!
    var instagramData: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instagramTableView.delegate = self
        instagramTableView.dataSource = self
        
        instagramTableView.rowHeight = 320
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
//                            NSLog("response: \(responseDictionary)")
                            
                            self.instagramData = responseDictionary.valueForKey("data") as? [NSDictionary]
                            self.instagramTableView.reloadData()
                    }
                }
        });
        task.resume()
    }
}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let instagramData = instagramData {
            return instagramData.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = instagramTableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        let post = instagramData![indexPath.row] as NSDictionary
        let imageUrl = ((post["images"] as! NSDictionary)["standard_resolution"] as! NSDictionary)["url"] as! String
        
        cell.postImageView.setImageWithURL(NSURL(string: imageUrl)!)
        return cell
    }
    
}

