//
//  PodcastManager.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import Foundation

class PodcastManager {
    
    func fetchPodcast(amount: Int, completion: @escaping ([Podcast]?) -> ()) {
        iTunesAPIEndpointRequest().getTopPodcastsIDs { (podcastIds: [String]?) in
            guard let podcastIds = podcastIds else { completion(nil); return }
            let currentPodcastIds = Array(podcastIds[0..<amount])
            
            self.fetchPodcastsHelper(podcastIds: currentPodcastIds) { (podcasts: [Podcast]?) in
                guard let podcasts = podcasts else { completion(nil); return }
                completion(podcasts)
            }
        }
    }
    
    fileprivate func fetchPodcastsHelper(podcastIds: [String], completion: @escaping ([Podcast]?) -> ()) {
        var podcasts: [Podcast] = []
        let dispatchGroup = DispatchGroup()
        
        for id in podcastIds {
            dispatchGroup.enter()
            
            iTunesAPIEndpointRequest().getRSSFeed(forArtistID: id) { (rssFeed: String?) in
                guard let rssFeed = rssFeed else {
                    completion(nil)
                    dispatchGroup.leave()
                    return
                }
                
                RSSFeedEndpointRequest(url: rssFeed).fetchPodcast { (podcast: Podcast?) in
                    guard let podcast = podcast else {
                        completion(nil)
                        dispatchGroup.leave()
                        return
                    }
                    
                    podcasts.insert(podcast, at: 0)
                    if podcasts.count == podcastIds.count {
                        completion(podcasts)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {}
        }
    }
}
