//
//  PlayerController.swift
//  assign5
//
//  Created by Josh on 5/16/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Firebase

class PlayerController : UIViewController {
    var playList: [String] = []
    var currentPosition = 0
    let player = AVPlayer(playerItem: nil)
    var handler: UInt? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        
        let likes = UILabel()
        view.addSubview(likes)
        likes.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true;
        likes.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 30).isActive = true;
        likes.text = "Like!"
        likes.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        likes.backgroundColor = #colorLiteral(red: 0.1486668925, green: 0.1486668925, blue: 0.1486668925, alpha: 1)
        
        let db = Database.database().reference()
        let urls = db.child("/urls")

        
        var postDict: [String: NSDictionary] = [:]
        handler = urls.observe(DataEventType.value, with: { (snapshot) in
            postDict = snapshot.value as? [String : NSDictionary] ?? [:]
            var newList: [String] = []
            for entry in postDict {
                newList.append(entry.value["url"] as? String ?? "")
            }
            print(postDict)
            print(newList)
            self.playList = newList
            if(!self.player.isPlaying){
                self.updatePlayer(0)
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc
    func playerDidFinishPlaying(){
        updatePlayer(currentPosition + 1)
    }
    
    func updatePlayer(_ position: Int){
        currentPosition = position
        if(currentPosition < playList.count){
            player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: playList[position])!))
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let x = handler {
            let db = Database.database().reference()
            let urls = db.child("/urls")
            urls.removeObserver(withHandle: x)
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
