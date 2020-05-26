//
//  NavigationController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: - Internal Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
