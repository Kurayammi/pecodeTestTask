//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import Foundation

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles = [ArticlesResponceModel]()
    var totalArticles = 0
    var currentPage = 1
    
    func onNextPageTapped() {
        
        if articles.count >= totalArticles { return }
        
        currentPage += 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage)).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                self.articles += articles
                self.totalArticles = total
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
        
        
    }
    
    func onFavouriteButtonTapped(At index: Int) {
        
    }
    
    func onRefresh() {
        
        currentPage = 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage)).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                
                self.articles = articles
                self.totalArticles = total
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
    }
}
