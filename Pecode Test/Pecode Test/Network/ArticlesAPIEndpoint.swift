//
//  ArticlesAPIEndpoint.swift
//  Pecode Test
//
//  Created by Kito on 11/4/22.
//

import Foundation

struct ArticlesAPIEndpoint {
    var scheme = "https"
    var host = "newsapi.org"
    
    var apiKey: String?
    var httpMethod = "GET"
    var path = "/v2/everything"
    
    var page: String
    
    var query: [String:String?]? {
        ["q": "Apple",
         "apiKey": UserConstats().apiKey,
         "pageSize": "10",
         "page": page]
        
    }
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        urlComponents.queryItems = query?.compactMap { key, value in
            return URLQueryItem(name: key, value: value)
        }
        return urlComponents.url!
    }
    
    init(page: String) {
        self.page = page
    }
}
