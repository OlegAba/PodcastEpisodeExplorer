//
//  System.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit

class System {
    
    static let shared = System()
    
    let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
}
