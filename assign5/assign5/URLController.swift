//
//  URLController.swift
//  assign5
//
//  Created by Josh on 5/16/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class URLController : UIViewController {
    
    @IBOutlet weak var videoTitle: UITextField!
    
    @IBOutlet weak var videoURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func upload(_ sender: Any) {
        if let name = videoTitle.text, let url = videoURL.text {
            if name == "" {
                return
            }
            if url == "" {
                return
            }
            addURLEntry(name: name, url: url)
        }
        
    }
    
    func addURLEntry(name: String, url: String){
        let root = Database.database().reference()
        root.child("urls").childByAutoId().setValue(["name": name, "url": url])
    }
    
}
