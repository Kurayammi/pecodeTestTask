//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import Foundation

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles: [ArticlesResponceModel]?
    
    func getArticles() {
        let url = ArticlesAPIEndpoint().url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                print( news.totalResults)
                
                self.articles = news.articles
            case .failure:
                print("failure")
            }
        }
    }
    
}
