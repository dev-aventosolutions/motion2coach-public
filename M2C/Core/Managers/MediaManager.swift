//
//  MediaManager.swift
//  M2C
//
//  Created by Abdul Samad Butt on 23/08/2022.
//

import Foundation
import UIKit
import AVKit

class MediaManager: UIViewController {

    var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        play(url: "")
    }

    func play (url: String) {
    
        player = AVPlayer(url: URL(string: url)!)
    
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
    
        self.present(playerViewController, animated: false) { self.player.play() }
    }
}
