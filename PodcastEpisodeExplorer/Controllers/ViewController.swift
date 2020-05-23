//
//  ViewController.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/22/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(topColor: UIColor.white, bottomColor: UIColor.appPink)
    }
}
