//
//  PodcastButtons.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class PodcastButtonsView: UIView {
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var centerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(centerButton)
        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(leftButton)
        addSubview(rightButton)
    }
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            centerButton.heightAnchor.constraint(equalToConstant: centerButton.intrinsicContentSize.height),
            centerButton.widthAnchor.constraint(equalTo: centerButton.heightAnchor),
            centerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            leftContainerView.topAnchor.constraint(equalTo: topAnchor),
            leftContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftContainerView.trailingAnchor.constraint(equalTo: centerButton.centerXAnchor),
            
            leftButton.heightAnchor.constraint(equalToConstant: leftButton.intrinsicContentSize.height),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
            leftButton.centerXAnchor.constraint(equalTo: leftContainerView.centerXAnchor),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightContainerView.topAnchor.constraint(equalTo: topAnchor),
            rightContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightContainerView.leadingAnchor.constraint(equalTo: centerButton.centerXAnchor),
            
            rightButton.heightAnchor.constraint(equalToConstant: rightButton.intrinsicContentSize.height),
            rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor),
            rightButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
