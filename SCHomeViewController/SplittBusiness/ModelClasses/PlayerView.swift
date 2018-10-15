//
//  PlayerView.swift
//  Splitt
//
//  Created by Deepali Gupta on 21/02/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
