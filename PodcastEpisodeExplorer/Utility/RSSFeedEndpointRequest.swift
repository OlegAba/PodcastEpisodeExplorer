//
//  RSSFeedEndpointRequest.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/24/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import Foundation
import FeedKit

class RSSFeedEndpointRequest {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    // NOTE: - Fetches RSS feed from url and parses into Podcast object
    func fetchPodcast(completion: @escaping (Podcast?) -> ()) {
        
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
                    let episodeTitle = episode.title,
                    let description = episode.description,
                    let length = episode.iTunes?.iTunesDuration,
                    let audioLink = episode.enclosure?.attributes?.url
                    else { completion(nil); return }
                
                let podcast = Podcast(title: title,
                                      episodeTitle: episodeTitle,
                                      imageUrl: imageUrl,
                                      description: description,
                                      length: length,
                                      audioUrl: audioLink)
                completion(podcast)
                
            case.failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
