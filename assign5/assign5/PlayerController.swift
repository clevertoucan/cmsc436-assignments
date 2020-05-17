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
    var playlist: [Video] = []
    var seenList: [String] = []
    let player = AVPlayer(playerItem: nil)
    var handler: UInt? = nil
    let likes = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    let likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    var seenInfoLoaded = false
    var timer: Timer!
    var currentVideo : Video!
    var playerLayer : AVPlayerLayer!
    
    @IBOutlet var playerView: PlayerView!
    @IBOutlet weak var defaultMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likes.text = "No likes"
        likes.font = likes.font.withSize(50)
        likes.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(likes)
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true;
        likes.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true;
        likes.setNeedsLayout()
        likes.setNeedsDisplay()
        likes.layer.zPosition = 2
        
        titleLabel.text = ""
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        titleLabel.setNeedsLayout()
        titleLabel.setNeedsDisplay()
        titleLabel.layer.zPosition = 2
        
        likeButton.isUserInteractionEnabled = false;
        likeButton.setTitle("👍", for: .normal)
        likeButton.titleLabel?.font = likeButton.titleLabel?.font.withSize(50)
        likeButton.addTarget(self, action: #selector(likeVideo), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        likeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        likeButton.setNeedsLayout()
        likeButton.layer.zPosition = 2
        
        playerLayer = playerView.layer as? AVPlayerLayer
        playerLayer.frame = view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = 1
        playerLayer.player = player
    
        
        let db = Database.database().reference()
        
        handler = db.observe(DataEventType.value, with: { (snapshot) in
            let seenDB = snapshot.childSnapshot(forPath: "/seen/sadpuppy")
            
            let dict = seenDB.value as? [String: AnyObject?] ?? [:]
            for entry in dict {
                var video = self.playlistContainsKey(entry.key)
                if video != nil {
                    video?.seen = true
                }
                self.seenList.append(entry.key)
            }
            self.seenInfoLoaded = true
            
            let urls = snapshot.childSnapshot(forPath: "/urls")
            let postDict = urls.value as? [String : NSDictionary] ?? [:]
            var newList: [Video] = []
            for entry in postDict {
                var numberOfLikes = 0
                let l = entry.value["likes"]
                if let videoLikes = l as? [String: Any?] {
                    numberOfLikes = videoLikes.count
                }
                if let url = entry.value["url"] as? String {
                    if self.currentVideo != nil && self.currentVideo.key == entry.key {
                        self.currentVideo.likes = numberOfLikes
                    }
                    let title = entry.value["name"] as? String ?? ""
                    let tags = entry.value["tags"] as? [String] ?? []
                    let video = self.playlistContainsKey(entry.key)
                    newList.append(Video(title: title, url: url, likes: numberOfLikes, key: entry.key, tags: tags, seen: (video?.seen ?? false || self.seenList.contains(entry.key))))
                }
            }
            self.playlist = newList
            self.updatePlayer()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(nextVideo))
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)

        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restart))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)

        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                restart()
            case .up:
                nextVideo()
            default:
                break
            }
        }
    }
    
    @objc
    func nextVideo(){
        player.pause()
        playerDidFinishPlaying()
    }
    @objc
    func restart(){
        player.seek(to: CMTime.zero)
    }
    
    @objc
    func playerDidFinishPlaying(){
        likeButton.isUserInteractionEnabled = false;
        if(playlist.count > 1){
            for i in 0...playlist.count - 1 {
                if playlist[i].key == currentVideo.key {
                    playlist.remove(at: i)
                    break;
                }
            }
            setSeen(currentVideo)
            updatePlayer()
        } else {
            playerLayer.isHidden = true;
            defaultMessage.text = "No more videos :("
            likes.isHidden = true;
            likeButton.isHidden = true;
            titleLabel.isHidden = true;
        }
    }
    
    func updatePlayer(){
        if(playlist.count > 0){
            if(!player.isPlaying){
                playlist.sort {
                    if ($0.seen && $1.seen || !$0.seen && !$1.seen) {
                        return $0.likes > $1.likes
                    } else {
                        return $1.seen
                    }
                }
                currentVideo = playlist[0]
                titleLabel.text = currentVideo.title
                likeButton.isUserInteractionEnabled = true;
                player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: currentVideo.url)!))
                player.play()
            }
            if currentVideo.likes == 0 {
                likes.text = "No likes"
            } else if(currentVideo.likes == 1) {
                likes.text = "1 like"
            } else {
                likes.text = "\(currentVideo.likes) likes"
            }
        }
    }
    
    @objc
    func likeVideo() {
        let video = playlist[0]
        let db = Database.database().reference()
        db.child("/urls/\(video.key)/likes/sadpuppy").setValue("1")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let db = Database.database().reference()
        if let x = handler {
            db.removeObserver(withHandle: x)
        }
    }
    
    func setSeen(_ video: Video){
        let seenDB = Database.database().reference().child("/seen/sadpuppy")
        seenDB.child(video.key).setValue(1)
    }
    
    func playlistContainsKey(_ key: String) -> Video?{
        for video in playlist {
            if(video.key == key) {
                return video;
            }
        }
        return nil;
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}

struct Video {
    var title: String
    var url: String
    var likes: Int
    var key: String
    var tags: [String]
    var seen: Bool
}
