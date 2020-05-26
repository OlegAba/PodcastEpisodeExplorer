//
//  PodcastButtons.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class PodcastButtonsView: UIView {
    
    lazy var playIconImage: UIImage? = {
        let image = UIImage(systemName: "play.fill", withConfiguration: centerIconConfig)
        return image
    }()
    
    lazy var pauseIconImage: UIImage? = {
        let image = UIImage(systemName: "pause.fill", withConfiguration: centerIconConfig)
        return image
    }()
    
    lazy var skipBackwardsButton: UIButton = {
        let button = UIButton()
        let backwardsIcon = UIImage(systemName: "gobackward.15", withConfiguration: skipIconConfig)
        button.setImage(backwardsIcon, for: .normal)
        button.tintColor = .appRed
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(playIconImage, for: .normal)
        button.tintColor = .appRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var skipForwardButton: UIButton = {
        let button = UIButton()
        let forwardIcon = UIImage(systemName: "goforward.30", withConfiguration: skipIconConfig)
        button.setImage(forwardIcon, for: .normal)
        button.tintColor = .appRed
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var leftContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var rightContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let skipIconConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold)
    fileprivate let centerIconConfig = UIImage.SymbolConfiguration(pointSize: 45.0, weight: .bold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(playPauseButton)
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(skipBackwardsButton)
        addSubview(skipForwardButton)
    }
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            playPauseButton.heightAnchor.constraint(equalToConstant: playPauseButton.intrinsicContentSize.height),
            playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            leftContainerView.topAnchor.constraint(equalTo: topAnchor),
            leftContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftContainerView.trailingAnchor.constraint(equalTo: playPauseButton.centerXAnchor),
            
            skipBackwardsButton.heightAnchor.constraint(equalToConstant: skipBackwardsButton.intrinsicContentSize.height),
            skipBackwardsButton.widthAnchor.constraint(equalTo: skipBackwardsButton.heightAnchor),
            skipBackwardsButton.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor),
            skipBackwardsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightContainerView.topAnchor.constraint(equalTo: topAnchor),
            rightContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightContainerView.leadingAnchor.constraint(equalTo: playPauseButton.centerXAnchor),
            
            skipForwardButton.heightAnchor.constraint(equalToConstant: skipForwardButton.intrinsicContentSize.height),
            skipForwardButton.widthAnchor.constraint(equalTo: skipForwardButton.heightAnchor),
            skipForwardButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor),
            skipForwardButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
