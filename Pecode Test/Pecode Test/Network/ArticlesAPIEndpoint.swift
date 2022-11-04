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
    var versionAPI = "/v2"
    var path = "/everything"
    
    var query: [String:String?]? {
        ["q": "Apple",
         "apiKey": UserConstats().apiKey,
         "pageSize": "5",
         "page": "1"]
        
    }
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = versionAPI + path
        
        urlComponents.queryItems = query?.compactMap { key, value in
            return URLQueryItem(name: key, value: value)
        }
        return urlComponents.url!
    }
}
