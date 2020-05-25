//
//  RSSFeedEndpointRequest.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/24/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import UIKit
import FeedKit

class RSSFeedEndpointRequest {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func fetchPodcast(completion: @escaping (String?) -> ()) {
        
        guard let feedUrl = URL(string: url) else { completion(nil); return }
        let parser = FeedParser(URL: feedUrl)
        
        parser.parseAsync { (result) in
            switch result {
            case .success(let feed):
                guard
                    let rssFeed = feed.rssFeed,
                    let title = rssFeed.title,
                    let imageUrl = rssFeed.image?.url,
                    let episode = rssFeed.items?.first,
                    let description = episode.description,
                    let length = episode.iTunes?.iTunesDuration,
                    let audioLink = episode.enclosure?.attributes?.url
                    else { completion(nil); return }
                
                // Init Podcast object and completion it
                
            case.failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
}
