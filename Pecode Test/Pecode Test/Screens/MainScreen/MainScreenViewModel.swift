//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import Foundation

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    private var articles: [ArticlesResponceModel]?
    var presenterArticles: [ArticlesResponceModel]?
    var totalArticles: Int?
    var currentPage = 0
    
    func getArticles() {
        let url = ArticlesAPIEndpoint().url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                self.articles = news.articles
                self.totalArticles = news.articles?.count
                self.presenterArticles = news.articles
                print("Done")
                
                self.onUpdate?()
                print("update")
            case .failure:
                print("failure")
            }
        }
        
        
    }
    
    func showArticles() {
        
    }
}
