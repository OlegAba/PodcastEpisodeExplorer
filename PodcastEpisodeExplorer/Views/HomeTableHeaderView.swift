//
//  HomeTableHeaderView.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class HomeTableHeaderView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .bold)
        let shareIcon = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        button.setImage(shareIcon, for: .normal)
        button.tintColor = .appRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var playAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play All", for: .normal)
        button.backgroundColor = UIColor.appRed
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        button.contentEdgeInsets.top = 13.0
        button.contentEdgeInsets.bottom = 13.0
        button.layer.cornerRadius = button.intrinsicContentSize.height / 2.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifetime
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        addSubview(titleLabel)
        addSubview(shareButton)
        addSubview(subtitleLabel)
        addSubview(playAllButton)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        let margin: CGFloat = 5.0
        
        NSLayoutConstraint.activate([
            shareButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: shareButton.intrinsicContentSize.height),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -(margin * 8.0)),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin * 2.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            playAllButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: margin),
            playAllButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            playAllButton.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor, multiplier: 1/2.2),
            playAllButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
