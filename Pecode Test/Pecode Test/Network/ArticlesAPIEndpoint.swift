//
//  ArticlesAPIEndpoint.swift
//  Pecode Test
//
//  Created by Kito on 11/4/22.
//

import Foundation

struct ArticlesAPIEndpoint {
    private var scheme = "https"
    private var host = "newsapi.org"
    private var apiKey: String?
    private var httpMethod = "GET"
    private var path = "/v2/everything"
    
    private var page: String
    private var searchFor: String
    
    private var query: [String:String?]? {
        ["q": searchFor,
         "apiKey": UserConstats().apiKey,
         "pageSize": "5",
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
    
    init(page: String,
         searchFor: String) {
        self.page = page
        self.searchFor = searchFor
    }
}
