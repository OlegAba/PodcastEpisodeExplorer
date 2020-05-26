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
    func pause()
}

class PodcastPlayerViewController: ViewController {
    
    // MARK: - Private Properties
    
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
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var podcastButtonsView: PodcastButtonsView = {
        let podcastButtonsView = PodcastButtonsView()
        podcastButtonsView.playPauseButton.addTarget(self, action: #selector(playPauseButtonWasTapped), for: .touchUpInside)
        podcastButtonsView.skipBackwardsButton.addTarget(self, action: #selector(skipBackwardsButtonWasTapped), for: .touchUpInside)
        podcastButtonsView.skipForwardButton.addTarget(self, action: #selector(skipForwardButtonWasTapped), for: .touchUpInside)
        podcastButtonsView.translatesAutoresizingMaskIntoConstraints = false
        return podcastButtonsView
    }()
    
    fileprivate var isPlaying = false {
        didSet {
            if isPlaying {
                SAPlayer.shared.play()
                podcastButtonsView.playPauseButton.setImage(podcastButtonsView.pauseIconImage, for: .normal)
            } else {
                SAPlayer.shared.pause()
                podcastButtonsView.playPauseButton.setImage(podcastButtonsView.playIconImage, for: .normal)
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPlaying = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        view.addSubview(gestureIndicatorView)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(podcastButtonsView)
    }
    
    // MARK: - Layout
    
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
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10.0),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10.0),
            
            podcastButtonsView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            podcastButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            podcastButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            podcastButtonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    
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

// MARK: - PodcastStreamDelegate
extension PodcastPlayerViewController: PodcastStreamDelegate {
    
    func update(ToPodcast podcast: Podcast) {
        titleLabel.text = podcast.episodeTitle
        subtitleLabel.text = podcast.title
        fetchImage(forUrl: podcast.imageUrl)
        streamAudio(forUrl: podcast.audioUrl)
    }
    
    func pause() {
        isPlaying = false
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
        SAPlayer.shared.stopStreamingRemoteAudio()
        SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
        isPlaying = true
    }
}
