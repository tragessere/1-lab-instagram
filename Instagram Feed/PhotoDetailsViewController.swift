//
//  PhotoDetailsViewController.swift
//  Instagram Feed
//
//  Created by Darrell Shi on 1/28/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    var photoUrl: String?
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoUrl = photoUrl {
            photoImageView.setImageWithURL(NSURL(string: photoUrl)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
