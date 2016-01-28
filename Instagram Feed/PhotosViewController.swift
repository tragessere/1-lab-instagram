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
  
    var loadingMoreView: InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var pageNumber = 2
  
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoDetailView = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = instagramTableView.indexPathForCell(sender as! UITableViewCell)
        let post = instagramData![indexPath!.section]
        photoDetailView.photoUrl = ((post["images"] as! NSDictionary)["standard_resolution"] as! NSDictionary)["url"] as? String
    }
}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let instagramData = instagramData {
            return instagramData.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = instagramTableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        let post = instagramData![indexPath.section] as NSDictionary
        let imageUrl = ((post["images"] as! NSDictionary)["standard_resolution"] as! NSDictionary)["url"] as! String
        
        //        let userData = post["user"] as! NSDictionary
        
        cell.postImageView.setImageWithURL(NSURL(string: imageUrl)!)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        
        let usernameLabel = UILabel(frame: CGRect(x: 50, y: 7, width: 200, height: 30))
        usernameLabel.font = UIFont(name: "System", size: 14.0)
        
        let post = instagramData![section] as NSDictionary
        let userData = post["user"] as! NSDictionary
        
        let profilePictureUrl = userData["profile_picture"] as! String
        let username = userData["username"] as! String
        
        //        let profilePictureUrl = userData["profile_picture"] as! String
        
        //        cell.usernameLabel.text = username
        //        cell.profilePictureView.setImageWithURL(NSURL(string: profilePictureUrl)!)
        
        profileView.setImageWithURL(NSURL(string: profilePictureUrl)!)
        usernameLabel.text = username
        
        headerView.addSubview(profileView)
        headerView.addSubview(usernameLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  
    func scrollViewDidScroll(scrollView: UIScrollView) {
      if !isMoreDataLoading {
        
        let scrollViewHeight = scrollView.contentSize.height
        let scrollOffsetThreshold = scrollViewHeight - scrollView.bounds.size.height
        
        if scrollView.contentOffset.y > scrollOffsetThreshold && scrollView.dragging {
          isMoreDataLoading = true
          
          loadMoreData()
        }
      }
    }
  
  func loadMoreData() {
    let session = NSURLSession(
        configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
        delegate: nil,
        delegateQueue: NSOperationQueue.mainQueue())
    
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)&page=\(pageNumber)")
    let request = NSURLRequest(URL: url!)

    
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { ( data, response, error) in
        
        if let data = data {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
              
              self.instagramData?.appendContentsOf(responseDictionary.valueForKey("data") as! [NSDictionary])
              self.instagramTableView.reloadData()
              
          }
        }
        self.isMoreDataLoading = false
        self.pageNumber++
    })
    task.resume()
  }
}

