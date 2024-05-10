//
//  RecordingPreviewViewController.swift
//  M2C
//
//  Created by Abdul Samad Butt on 23/08/2022.
//

import UIKit
import AVKit

protocol RecordingPreviewProtocol: AnyObject{
    func showProgress()
}

class RecordingPreviewViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var btnRetake: UIButton!
    
    //MARK: VARIABLES
    var onRetake: (() -> Void)?
    var onViewSession: (() -> Void)?
    var videoLink: URL?
    var isVideoPlaying: Bool = true
    weak var videoSettings: VideoRecordingSettings?
    weak var delegate: RecordingSettingsProtocol?
    
    let playerController = AVPlayerViewController()
    fileprivate var player: AVPlayer! {playerController.player}
    fileprivate var asset: AVAsset!
    var capture: CaptureModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.videoView.clipsToBounds = true
        showAnimate()
        playVideo()
        
    }
    
    private func playVideo(){
        
        if let videoLink = videoLink{
            
            asset = AVAsset(url: videoLink)
            
            playerController.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
            videoView.addSubview(playerController.view)
            videoView.layer.cornerRadius = 10
            playerController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playerController.view.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
                playerController.view.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
                playerController.view.topAnchor.constraint(equalTo: videoView.topAnchor),
                playerController.view.widthAnchor.constraint(equalTo: videoView.widthAnchor),
                playerController.view.heightAnchor.constraint(equalTo: videoView.safeAreaLayoutGuide.heightAnchor) ])
            
            player.play()
        }
    }
    
    //MARK: ACTIONS
    @IBAction func btnRetakeClicked(_ sender: Any) {
        onRetake?()
        removeAnimate()
    }
    
    
    @IBAction func btnSessionsClicked(_ sender: Any) {
        onViewSession?()
        removeAnimate()
    }
    
}
