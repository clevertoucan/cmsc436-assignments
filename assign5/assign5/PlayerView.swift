//
//  PlayerView.swift
//  assign5
//
//  Created by Josh on 5/16/20.
//  Copyright © 2020 Josh. All rights reserved.
//
// Taken from: https://stackoverflow.com/questions/10126200/avplayer-layer-inside-a-view-does-not-resize-when-uiview-frame-changes
import UIKit
import AVFoundation

class PlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
