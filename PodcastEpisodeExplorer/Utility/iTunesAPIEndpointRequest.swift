//
//  iTunesAPIEndpointRequest.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/23/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import Foundation

// Top Podcasts

fileprivate struct TopPodcastsDescription: Decodable {
    let feed: TopPodcastsFeed
}

fileprivate struct TopPodcastsFeed: Decodable {
    let results: [TopPodcastsResults]
}

fileprivate struct TopPodcastsResults: Decodable {
    let id: String
}

// Artist Lookup

fileprivate struct ArtistSearchDescription: Decodable {
    let results: [ArtistSearchResults]
}

fileprivate struct ArtistSearchResults: Decodable {
    let feedUrl: String
}


class iTunesAPIEndpointRequest {
    
    // getNext10Podcasts -> Podcast(model)
    
    func getTopPodcastsIDs(completion: @escaping ([String]?) -> ()) {
        
        let urlString = "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/all/100/explicit.json"
        guard let url = URL(string: urlString) else { completion(nil); return }
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let data = data, error == nil
            else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let errorMessage = error?.localizedDescription
                
                print("\n---Request Failed---")
                print("URL: \(url)")
                print("Status Code: \(String(describing: statusCode))")
                print("Error Message: \(String(describing: errorMessage))")
                
                completion(nil)
                return
            }
            
            do {
                let description = try JSONDecoder().decode(TopPodcastsDescription.self, from: data)
                let ids = description.feed.results.map { (result: TopPodcastsResults) in
                    return result.id
                }
                completion(ids)
                
            } catch let jsonError {
                print("Error serializing json: \(jsonError)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func getRSSFeed(forArtistID artistID: String, completion: @escaping (String?) -> ()) {
        
        let urlString = "https://itunes.apple.com/lookup?id=\(artistID)"
        guard let url = URL(string: urlString) else { completion(nil); return }
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let data = data, error == nil
            else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let errorMessage = error?.localizedDescription
                
                print("\n---Request Failed---")
                print("URL: \(url)")
                print("Status Code: \(String(describing: statusCode))")
                print("Error Message: \(String(describing: errorMessage))")
                
                completion(nil)
                return
            }
            
            do {
                let description = try JSONDecoder().decode(ArtistSearchDescription.self, from: data)
                let firstResult = description.results[0]
                completion(firstResult.feedUrl)
                
            } catch let jsonError {
                print("Error serializing json: \(jsonError)")
                completion(nil)
                return
            }
        }.resume()
    }
    
}
