//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit
import CoreData

enum LoadingState {
    case refresh
    case loadNextPage
}

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles = [ArticlesModel]()
    
    private var totalArticles = 0
    private var currentPage = 1
    private var searchFor = ""
    
    private let imageCash = NSCache<NSString, UIImage>()
    
    func loadArticles(state: LoadingState) {
        
        switch state {
        case .refresh:
            currentPage = 1
            
        case .loadNextPage:
            
            if articles.count >= totalArticles { return }
            currentPage += 1
        }
        
        let url = ArticlesAPIEndpoint(page: String(currentPage),
                                      searchFor: searchFor).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) {  result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else {
                    self.onUpdate?()
                    return }
                guard let total = news.totalResults else {
                    self.onUpdate?()
                    return }
                
                switch state {
                case .refresh:
                    self.articles = []
                    self.imageCash.removeAllObjects()
                case .loadNextPage: break
                }
                
                for news in articles {
                    let image = self.loadImageByUrlPath(path: news.urlToImage)
                    let newArticle = ArticlesModel(source: news.source?.name ?? "",
                                                   author: news.author ?? "",
                                                   title: news.title ?? "",
                                                   description: news.description ?? "",
                                                   url: news.url ?? "",
                                                   image: image,
                                                   publishedAt: news.publishedAt ?? "")
                    
                    self.articles.append(newArticle)
                }
                
                self.totalArticles = total
                
                print(articles)
                self.syncCoreDataWithCurrentArticles()
                
            case .failure:
                print("failure")
            }
        }
        
    }
    
    func onFavouriteButtonTapped(At index: Int) {
        let dbManager = ArticlesDatabaseManager()
        
        if articles[index].isSaved {
            
            articles[index].isSaved = false
            dbManager.deleteEntityFromCoreData(title: articles[index].title)
        } else {
            
            articles[index].isSaved = true
            dbManager.saveArticleToCoreData(articleToSave: articles[index])
        }
        
        onUpdate?()
    }
    
    func onSearchButtonTapped(searchText: String) {
        searchFor = searchText
        loadArticles(state: .refresh)
    }
      
    func syncCoreDataWithCurrentArticles() {
        
        DispatchQueue.main.async {
            let dbManager = ArticlesDatabaseManager()
            
            if let savedArticles = dbManager.fetchArticlesFromCoreData() {
                
                for index in (0 ..< self.articles.count) {
                    self.articles[index].isSaved = false
                }
                
                for saved in savedArticles {
                    for index in (0 ..< self.articles.count) {
                        
                        if saved.title == self.articles[index].title {
                            self.articles[index].isSaved = true
                        }
                    }
                }
                
               
            }
        }
        
        onUpdate?()
    }
    
    func loadImageByUrlPath(path: String?) -> UIImage? {
        
        guard let path = path else { return nil }
        if let cashedImage = imageCash.object(forKey: NSString(string: path as NSString)) {
            return cashedImage
            
        } else {
            
            // load image by url and save in cache
            
            guard let url = URL(string: path ) else {return nil }
            
            guard let data = try? Data(contentsOf: url) else { return nil }
            guard let image: UIImage = UIImage(data: data) else { return nil}
            
            DispatchQueue.main.async {
                self.imageCash.setObject(image, forKey: NSString(string: path as NSString))
            }
            
            return image
        }
    }
}
