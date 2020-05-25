//
//  AudioPlayerViewController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit
import SwiftAudioPlayer

protocol PodcastStreamDelegate {
    func update(ToPodcast podcast: Podcast)
}

class PodcastPlayerViewController: ViewController {
    
    fileprivate lazy var gestureIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appPink
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var podcastButtonsView: PodcastButtonsView = {
        let podcastButtonsView = PodcastButtonsView()
        
        podcastButtonsView.centerButton.setImage(playIconImage, for: .normal)
        podcastButtonsView.centerButton.tintColor = .appRed
        podcastButtonsView.centerButton.addTarget(self, action: #selector(playPauseButtonWasTapped), for: .touchUpInside)
        
        let skipIconConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold)
        
        let backwardsIcon = UIImage(systemName: "gobackward.15", withConfiguration: skipIconConfig)
        podcastButtonsView.leftButton.setImage(backwardsIcon, for: .normal)
        podcastButtonsView.leftButton.tintColor = .appRed
        podcastButtonsView.leftButton.addTarget(self, action: #selector(skipBackwardsButtonWasTapped), for: .touchUpInside)
        
        let forwardIcon = UIImage(systemName: "goforward.30", withConfiguration: skipIconConfig)
        podcastButtonsView.rightButton.setImage(forwardIcon, for: .normal)
        podcastButtonsView.rightButton.tintColor = .appRed
        podcastButtonsView.rightButton.addTarget(self, action: #selector(skipForwardButtonWasTapped), for: .touchUpInside)
        
        podcastButtonsView.translatesAutoresizingMaskIntoConstraints = false
        return podcastButtonsView
    }()
    
    fileprivate lazy var playIconImage: UIImage? = {
        let image = UIImage(systemName: "play.fill", withConfiguration: centerIconConfig)
        return image
    }()
    
    fileprivate lazy var pauseIconImage: UIImage? = {
        let image = UIImage(systemName: "pause.fill", withConfiguration: centerIconConfig)
        return image
    }()
    
    fileprivate let centerIconConfig = UIImage.SymbolConfiguration(pointSize: 45.0, weight: .bold)
    
    fileprivate var isPlaying = false {
        didSet {
            if isPlaying {
                SAPlayer.shared.play()
                podcastButtonsView.centerButton.setImage(pauseIconImage, for: .normal)
            } else {
                SAPlayer.shared.pause()
                podcastButtonsView.centerButton.setImage(playIconImage, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(gestureIndicatorView)
        view.addSubview(logoImageView)
        view.addSubview(podcastButtonsView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            gestureIndicatorView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10.0),
            gestureIndicatorView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            gestureIndicatorView.heightAnchor.constraint(equalToConstant: 5.0),
            gestureIndicatorView.widthAnchor.constraint(equalToConstant: 50.0),
            
            logoImageView.topAnchor.constraint(equalTo: gestureIndicatorView.bottomAnchor, constant: 40.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.7),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            podcastButtonsView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40.0),
            podcastButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            podcastButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            podcastButtonsView.heightAnchor.constraint(equalToConstant: 200.0),
        ])
    }
    
    @objc fileprivate func playPauseButtonWasTapped() {
        isPlaying = !isPlaying
    }
    
    @objc fileprivate func skipBackwardsButtonWasTapped() {
        SAPlayer.shared.skipBackwards()
    }
    
    @objc fileprivate func skipForwardButtonWasTapped() {
        SAPlayer.shared.skipForward()
    }
}

extension PodcastPlayerViewController: PodcastStreamDelegate {
    
    func update(ToPodcast podcast: Podcast) {
        fetchImage(forUrl: podcast.imageUrl)
        streamAudio(forUrl: podcast.audioUrl)
    }
    
    fileprivate func fetchImage(forUrl url: String) {
        
        let imageKey = NSString(string: url)
        if let imageFromCache = System.shared.imageCache.object(forKey: imageKey) {
            logoImageView.image = imageFromCache
            return
        }
        
        EndpointRequest(url: url).getData { (data: Data?) in
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.logoImageView.image = image
                    System.shared.imageCache.setObject(image, forKey: imageKey)
                }
            }
        }
    }
    
    fileprivate func streamAudio(forUrl url: String) {
        guard let url = URL(string: url) else { return }
        SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
        isPlaying = true
    }
}
