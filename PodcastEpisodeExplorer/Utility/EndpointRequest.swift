//
//  EndpointRequest.swift
//  PodcastEpisodeExplorer
//
//  Created by Oleg Abalonski on 5/23/20.
//  Copyright © 2020 Oleg Abalonski. All rights reserved.
//

import Foundation

class EndpointRequest {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func getData(completion: @escaping (Data?) -> ()) {
        
        guard let url = URL(string: url) else { completion(nil); return }
        
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
            
            completion(data)
            
        }.resume()
    }
}
