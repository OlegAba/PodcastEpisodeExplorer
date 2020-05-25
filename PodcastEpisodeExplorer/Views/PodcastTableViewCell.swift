//
//  PodcastTableViewCell.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        view.layer.cornerRadius = 35.0
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appPink
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var topIconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bottomIconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var logoImageUrl: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(topIconButton)
        containerView.addSubview(bottomIconButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(captionLabel)
    }
    
    func layoutViews() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 55.0),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            topIconButton.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: -10.0),
            topIconButton.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            topIconButton.heightAnchor.constraint(equalToConstant: topIconButton.intrinsicContentSize.height),
            topIconButton.widthAnchor.constraint(equalTo: topIconButton.heightAnchor),
            
            bottomIconButton.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor, constant: 10.0),
            bottomIconButton.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            bottomIconButton.heightAnchor.constraint(equalToConstant: topIconButton.intrinsicContentSize.height),
            bottomIconButton.widthAnchor.constraint(equalTo: topIconButton.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: topIconButton.leadingAnchor, constant:  -5.0),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: topIconButton.leadingAnchor, constant:  -5.0),
            
            captionLabel.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),
            captionLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10.0),
            captionLabel.trailingAnchor.constraint(equalTo: topIconButton.leadingAnchor, constant:  -5.0),
        ])
    }
    
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
