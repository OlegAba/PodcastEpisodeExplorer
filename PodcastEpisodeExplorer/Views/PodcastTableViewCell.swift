//
//  PodcastTableViewCell.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

protocol PodcastTableViewCellDelegate {
    func podcastTableViewCellMoreButtonWasTapped(_ podcastTableViewCell: PodcastTableViewCell)
    func podcastTableViewCellPlayPauseButtonWasTapped(_ podcastTableViewCell: PodcastTableViewCell)
}

class PodcastTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        view.layer.cornerRadius = 35.0
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appPink
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var moreIconButton: UIButton = {
        let button = UIButton()
        let moreIcon = UIImage(systemName: "ellipsis", withConfiguration: iconConfig)
        button.setImage(moreIcon, for: .normal)
        button.tintColor = .appRed
        button.addTarget(self, action: #selector(moreButtonWasTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var playPauseIconButton: UIButton = {
        let button = UIButton()
        let playIcon = UIImage(systemName: "play.circle", withConfiguration: iconConfig)
        button.setImage(playIcon, for: .normal)
        button.tintColor = .appRed
        button.addTarget(self, action: #selector(playPauseButtonWasTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconConfig = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .bold)
    var delegate: PodcastTableViewCellDelegate!
    var logoImageUrl: String?
    
    // MARK: - Lifetime
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(moreIconButton)
        containerView.addSubview(playPauseIconButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(captionLabel)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 55.0),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            moreIconButton.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: -5.0),
            moreIconButton.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            moreIconButton.heightAnchor.constraint(equalToConstant: moreIconButton.intrinsicContentSize.height),
            moreIconButton.widthAnchor.constraint(equalToConstant: moreIconButton.intrinsicContentSize.width),
            
            playPauseIconButton.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor, constant: 5.0),
            playPauseIconButton.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            playPauseIconButton.heightAnchor.constraint(equalToConstant: playPauseIconButton.intrinsicContentSize.height),
            playPauseIconButton.widthAnchor.constraint(equalToConstant: playPauseIconButton.intrinsicContentSize.width),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: moreIconButton.leadingAnchor, constant:  -10.0),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: moreIconButton.leadingAnchor, constant:  -10.0),
            
            captionLabel.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            captionLabel.trailingAnchor.constraint(equalTo: moreIconButton.leadingAnchor, constant:  -10.0),
        ])
    }
    
    // MARK: - Actions

    @objc fileprivate func moreButtonWasTapped() {
        delegate.podcastTableViewCellMoreButtonWasTapped(self)
    }
    
    @objc fileprivate func playPauseButtonWasTapped() {
        delegate.podcastTableViewCellPlayPauseButtonWasTapped(self)
    }
    
    // MARK: - Internal Methods
    
    func fetchImage(forUrl url: String) {
        
        logoImageUrl = url
        logoImageView.image = nil
        
        let imageKey = NSString(string: url)
        if let imageFromCache = System.shared.imageCache.object(forKey: imageKey) {
            logoImageView.image = imageFromCache
            return
        }
        
        EndpointRequest(url: url).getData { (data: Data?) in
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if (self.logoImageUrl == url) {
                        self.logoImageView.image = image
                    }
                    
                    System.shared.imageCache.setObject(image, forKey: imageKey)
                }
            }
        }
    }
}
