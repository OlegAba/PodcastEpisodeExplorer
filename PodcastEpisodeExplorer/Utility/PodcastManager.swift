//
//  PodcastManager.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/25/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import Foundation

class PodcastManager {
    
    var ids: [String]?
    var currentIndex: Int = 0
    
    fileprivate var idsFetched = false
    
    func fetchNext(amount: Int, completion: @escaping ([Podcast]?) -> ()) {
        
        if !idsFetched {
            iTunesAPIEndpointRequest().getTopPodcastsIDs { (podcastIds: [String]?) in
                guard let podcastIds = podcastIds else { completion(nil); return }
                self.ids = podcastIds
                self.idsFetched = true
                
                self.fetchPodcasts(amount: amount) { (podcasts: [Podcast]?) in
                    guard let podcasts = podcasts else { completion(nil); return }
                    completion(podcasts)
                }
            }
        } else {
            fetchPodcasts(amount: amount) { (podcasts: [Podcast]?) in
                guard let podcasts = podcasts else { completion(nil); return }
                completion(podcasts)
            }
        }
    }
    
    fileprivate func fetchPodcasts(amount: Int, completion: @escaping ([Podcast]?) -> ()) {
        
        guard let ids = self.ids else { completion(nil); return }
        let lastIndex: Int = currentIndex + amount
        let currentIds = Array(ids[currentIndex..<lastIndex])
        
        var podcasts: [Podcast] = []
        let dispatchGroup = DispatchGroup()
        
        for currentId in currentIds {
            dispatchGroup.enter()
            
            iTunesAPIEndpointRequest().getRSSFeed(forArtistID: currentId) { (rssFeed: String?) in
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
                    
                    podcasts.append(podcast)
                    if podcasts.count == currentIds.count {
                        self.currentIndex = lastIndex
                        completion(podcasts)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {}
        }
    }
}
