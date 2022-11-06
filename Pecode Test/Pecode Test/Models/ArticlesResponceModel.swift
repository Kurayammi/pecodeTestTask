//
//  ArticlesResponceModel.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import Foundation

struct NewsResponseModel: Codable {
    let totalResults: Int?
    let articles: [ArticlesResponceModel]?
}

struct ArticlesResponceModel: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    struct Source: Codable {
        let name: String?
    }
}
