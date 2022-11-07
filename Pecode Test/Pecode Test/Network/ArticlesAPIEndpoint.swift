//
//  ArticlesAPIEndpoint.swift
//  Pecode Test
//
//  Created by Kito on 11/4/22.
//

import Foundation

enum CountryList: String, CaseIterable {
    case ae = "ae"
    case ar = "ar"
    case at = "at"
    case au = "au"
    case ua = "ua"
    case us = "us"
    
    var stringValue: String {
        switch self {
        case .ae: return "ae"
        case .ar: return "ar"
        case .at: return "at"
        case .au: return "au"
        case .ua: return "ua"
        case .us: return "us"
        }
    }
}

enum CategoryList: String, CaseIterable{
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
    
    var stringValue: String {
        switch self {
        case .business:         return "business"
        case .entertainment:    return "entertainment"
        case .general:          return "general"
        case .health:           return "health"
        case .science:          return "science"
        case .sports:           return "sports"
        case .technology:       return "technology"
        }
    }
}

struct ArticlesAPIEndpoint {
    
    private var scheme = "https"
    private var host = "newsapi.org"
    private var apiKey: String?
    private var httpMethod = "GET"
    //private var path = "/v2/everything"
    private var path = "/v2/top-headlines"
    
    private var page: String
    private var searchFor: String
    private var country: String?
    private var category: String?
    
    private var query: [String:String?]? {
       var quary  = ["q": searchFor,
         "apiKey": UserConstats().apiKey,
         "pageSize": "5",
         "page": page]
        
        if let category = category {
            quary["category"] = category
        }
        
        if let country = country {
            quary["country"] = country
        }
        
        return quary
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
         searchFor: String,
         country: String? = nil,
         category: String? = nil) {
        
        self.page = page
        self.searchFor = searchFor
        self.country = country
        self.category = category
    }
}
