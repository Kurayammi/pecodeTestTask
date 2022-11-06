//
//  MainScreenViewModel.swift
//  Pecode Test
//
//  Created by Kito on 11/3/22.
//

import UIKit
import CoreData

final class MainScreenViewModel {
    
    var onUpdate: (() ->Void)?
    var articles = [ArticlesModel]()
    
    private var totalArticles = 0
    private var currentPage = 1
    private var searchFor = ""
    
    private let imageCash = NSCache<NSString, UIImage>()
    
    func onNextPageTapped() {
        
        if articles.count >= totalArticles { return }
        
        currentPage += 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage),
                                      searchFor: searchFor).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                
                for news in articles {
                    let newArticle = ArticlesModel(source: news.source?.name ?? "",
                                                  author: news.author ?? "",
                                                  title: news.title ?? "",
                                                  description: news.description ?? "",
                                                  url: news.url ?? "",
                                                  urlToImage: news.urlToImage ?? "",
                                                  publishedAt: news.publishedAt ?? "")
                    
                    self.articles.append(newArticle)
                }
                
                self.totalArticles = total
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
        
        
    }
    
    func onFavouriteButtonTapped(At index: Int) {
        let dbManager = ArticlesDatabaseManager()
        var article = articles[index]
        
        if articles[index].isSaved {
            
            articles[index].isSaved = false
            dbManager.deleteEntityFromCoreData(title: article.title)
        } else {
            
            articles[index].isSaved = true
            dbManager.saveArticleToCoreData(articleToSave: article)
        }
        
        onUpdate?()
    }
    
    func onSearchButtonTapped(searchText: String) {
        searchFor = searchText
        onRefresh()
    }
    
    func onRefresh() {
        
        currentPage = 1
        
        let url = ArticlesAPIEndpoint(page: String(currentPage),
                                      searchFor: searchFor).url
        
        let nm = NetworkManager()
        
        nm.sendRequest(with: url, objectType: NewsResponseModel.self) { result in
            
            switch result {
            case .success(let news):
                guard let articles = news.articles else { return }
                guard let total = news.totalResults else { return }
                
                self.articles = []
                
                for news in articles {
                    let newArticle = ArticlesModel(source: news.source?.name ?? "",
                                                  author: news.author ?? "",
                                                  title: news.title ?? "",
                                                  description: news.description ?? "",
                                                  url: news.url ?? "",
                                                  urlToImage: news.urlToImage ?? "",
                                                  publishedAt: news.publishedAt ?? "")
                    
                    self.articles.append(newArticle)
                }
                
                self.totalArticles = total
                self.imageCash.removeAllObjects()
                
                print(articles)
                self.onUpdate?()
                
            case .failure:
                print("failure")
            }
        }
    }
    
    func loadImageByIndex(index: Int) -> UIImage? {
        let indexString = String(index)
        
        if let cashedImage = imageCash.object(forKey: NSString(string: indexString as NSString)) {
            return cashedImage
            
        } else {
            
            // load image by url and save in cache
            
            let adress = articles[index].urlToImage
            guard let url = URL(string: adress ) else {return nil }
            
            guard let data = try? Data(contentsOf: url) else { return nil }
            guard let image: UIImage = UIImage(data: data) else { return nil}
            
            DispatchQueue.main.async {
                self.imageCash.setObject(image, forKey: NSString(string: indexString as NSString))
            }
            
            return image
        }
    }
}
